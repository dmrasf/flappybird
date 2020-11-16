% 使用空格键控制小球跳跃躲避障碍
% 使用shift键暂停
% 使用空格恢复移动
function flappybird()
% 音设置
fs=4410;
t1 = 0: 1/fs: 0.05;
t2 = 0: 1/fs: 0.2;
song1 = sin(2*pi*1000*t1);
song2 = sin(2*pi*200*t2);
% 运动函数初始化
tim = 0;
v0 = 50/17;            % 设置小球蹦的高度
g = 10/17;
T = 0.02;              % 刷新的周期  可改变难度
flag = 0;               % 按键flag
% 障碍初始化
min_length = 0;         % 障碍消失的地方
max_length = 150;       % 游戏的宽度
high = 20;              % 障碍的高度
bottom = 20;            % 小球的底部
n_add = 0.95;            % 前进的格数  可改变障碍前进的速度
space_t = 0.4;          % 小球时间  可改变小球蹦跶的快慢
barriers = [160, 164, 10, high + 10]; 
dis = barriers(1, 2);   % 最远障碍的距离
% 打开保存记录的文件
record = fopen('record.txt', 'r');
r = fscanf(record, '%d', 1);
fclose(record);
grade = 0;              % 当前分数
o_g = 0;                % 当前分数
% 小球初始化
ball = struct('x', 20, 'y', bottom, 'flag', 0);
% 绘制背景
bak = ['w', 'k'; 'k', 'w'];  % 随时间变化背景
title(sprintf('HI    %05d    %05d', r, grade), 'position',[120,60]);
axis equal
axis([0, max_length, 0, 55])          
set(gca,'xtick',[],'ytick',[],'xcolor','w','ycolor','w')
set(gca, 'color', 'w')
hold on
% 绘制小球
b = scatter(gca, ball.x, ball.y, 50, 'rs', 'filled');
% 绘制障碍
x1 = [barriers(1, 1), barriers(1, 2), barriers(1, 2), barriers(1, 1)];
y1 = [0, 0, barriers(1, 3), barriers(1, 3)];
x2 = [barriers(1, 1), barriers(1, 2), barriers(1, 2), barriers(1, 1)];
y2 = [barriers(1, 4), barriers(1, 4), 55, 55];      
pa1 = fill(x1, y1, 'k');
pb1 = fill(x2, y2, 'k');
pa2 = fill(x1, y1, 'k');
pb2 = fill(x2, y2, 'k');
pa3 = fill(x1, y1, 'k');
pb3 = fill(x2, y2, 'k');
% 分配空间
a = [pa1, pb1; pa2, pb2; pa3, pb3];
% 随机障碍初始化
cube = [700, 40];
add = 0.5;
d = scatter(gca, cube(1), cube(2), 100, 'bd', 'filled');
% 监控键盘消息
set(gcf, 'KeyPressFcn', @key)
% 设置定时器的参数   fixedRate：第一次TimeFcn开始排队到第二次TimeFcn开始排队之间的时间为定时周期
ball_game = timer('ExecutionMode', 'FixedRate', 'Period', T, 'TimerFcn', @f); 
start(ball_game)
    function f(~, ~)
        % 随机产生障碍
        changdu = max_length + round(unifrnd(80, 150, 1));  % 离上一个障碍的距离
        k = round(unifrnd(3, 5, 1, 1));                     % 障碍的宽度
        high = round(unifrnd(15, 20, 1, 1));                % 障碍的高度
        base = round(unifrnd(0, 35, 1, 1));                 % 障碍的底部
        % 判断障碍是否可以放入障碍数组中
        if dis == 0 || dis < max_length
            barriers = [barriers; changdu, changdu + k, base, high + base];
            dis = changdu + k;
        end
        % 判断障碍是否到达给定的边界
        if barriers(1, 2) <= min_length
            barriers(1,:) = [];                             % 删除第一个障碍
        end
        if cube(1) < min_length       % 随机生成方块
            cube(1) = round(unifrnd(200, 400, 1));
            cube(2) = round(unifrnd(20, 30, 1));
        end
        % 每到时间 移动障碍
        l = length(barriers(:, 1));
        barriers(:, 1) = barriers(:, 1) - n_add;
        barriers(:, 2) = barriers(:, 2) - n_add;
        % 移动方块
        cube(1) = cube(1) - add;
        % 更新最远距离
        dis = barriers(l, 2);
        % 判断小球是否与障碍相撞 
        if ball.y < 2 || ball.y > 53 ...
            || ball.x <= barriers(1, 2) && ball.x >= barriers(1, 1) && ~(ball.y >= barriers(1, 3) && ball.y <= barriers(1, 4) ...
                || (ball.x > cube(1)-2.5 && ball.y > cube(2) - 2.5 && ball.x < cube(1) + 2.5 && ball.y < cube(2) + 2.5))
            if r == grade                                   % 更新记录
                record = fopen('record.txt', 'w');          % 打开文件  会删除掉原有内容
                fprintf(record, '%d', r);                   % 写入新的记录
                fclose(record);                             % 关闭文件
            end
            soundsc(song2, fs)
            stop(ball_game)
            ButtonName = questdlg('GAME  OVER！', 'Gave Over', '继续', '重新开始', '关闭游戏', '继续');
            switch ButtonName
                case '继续'
                    % 判断小球是否与障碍和随机障碍相撞
                    if ball.x >= barriers(1, 2) || ball.x <= barriers(1, 1)
                        ball.y = 20;
                        bottom = ball.y;
                        tim = 0;
                        ball.flag = 0;
                    elseif (ball.x > cube(1)-2.5 && ball.y > cube(2) - 2.5 && ball.x < cube(1) + 2.5 && ball.y < cube(2) + 2.5)
                        cube(1) = cube(1) - 10;
                    else
                        barriers(1, 1) = barriers(1, 1) - 10;   % 将障碍前移10  避开小球
                        barriers(1, 2) = barriers(1, 2) - 10;                   
                    end
                    % o_g = 0;
                    start(ball_game)
                case '关闭游戏'
                    delete(ball_game)
                    close;
                    return
                case '重新开始'
                    delete(ball_game)
                    close;
                    m7_56_ballgame()
                    return
                otherwise
                    clear, clc, close all
                    return
            end
        end
        % 小球移动
        if ball.flag == 1
            tim = tim + space_t;
            % 方程
            % t = 0:0.1:10;    v0 = 50/12;      g = 10/12;
            % y = v0.*t-0.5*g.*t.^2;
            % plot(t, y)
            ball.y = bottom + v0 * tim - 0.5 * g * tim^2;
        end
        % 更新分数
        o_g = o_g + 1;
        grade = int16(o_g / 30);
        if grade > r
            r = grade;
        end
        % 更新绘图
        title(sprintf('HI    %05d    %05d', r, grade));
        set(b, 'XData', ball.x,  'YData', ball.y);  % 小球
        set(d, 'XData', cube(1),  'YData', cube(2)); 
        temp = 0;
        if grade > 99
        temp = rem(grade/100, 2);
        end
        set(gca, 'color', bak(temp+1, 1))  % 每隔100背景色换一下
        for p = 1:l    % 障碍
            x1 = [barriers(p, 1), barriers(p, 2), barriers(p, 2), barriers(p, 1)];
            y1 = [0, 0, barriers(p, 3), barriers(p, 3)];
            x2 = [barriers(p, 1), barriers(p, 2), barriers(p, 2), barriers(p, 1)];
            y2 = [barriers(p, 4), barriers(p, 4), 55, 55];      
            set(a(p, 1),'XData', x1,  'YData', y1, 'FaceColor', bak(temp+1, 2)); 
            set(a(p, 2),'XData', x2,  'YData', y2, 'FaceColor', bak(temp+1, 2));
        end
    end
    function key(~,event)  % 键盘消息处理
        switch event.Key
            case 'space'   % 控制小球或继续
                if flag == 1
                    start(ball_game)
                    flag = 0;
                    pause(1)
                else
                    ball.flag = 1;
                    bottom = ball.y;
                    tim = 0;
                    soundsc(song1, fs)
                end
            case 'shift'  % 暂停
                stop(ball_game)
                flag = 1;
             otherwise
                return
        end
    end
  end