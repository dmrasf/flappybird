% ʹ�ÿո������С����Ծ����ϰ�
% ʹ��shift����ͣ
% ʹ�ÿո�ָ��ƶ�
function flappybird()
% ������
fs=4410;
t1 = 0: 1/fs: 0.05;
t2 = 0: 1/fs: 0.2;
song1 = sin(2*pi*1000*t1);
song2 = sin(2*pi*200*t2);
% �˶�������ʼ��
tim = 0;
v0 = 50/17;            % ����С��ĵĸ߶�
g = 10/17;
T = 0.02;              % ˢ�µ�����  �ɸı��Ѷ�
flag = 0;               % ����flag
% �ϰ���ʼ��
min_length = 0;         % �ϰ���ʧ�ĵط�
max_length = 150;       % ��Ϸ�Ŀ��
high = 20;              % �ϰ��ĸ߶�
bottom = 20;            % С��ĵײ�
n_add = 0.95;            % ǰ���ĸ���  �ɸı��ϰ�ǰ�����ٶ�
space_t = 0.4;          % С��ʱ��  �ɸı�С����Q�Ŀ���
barriers = [160, 164, 10, high + 10]; 
dis = barriers(1, 2);   % ��Զ�ϰ��ľ���
% �򿪱����¼���ļ�
record = fopen('record.txt', 'r');
r = fscanf(record, '%d', 1);
fclose(record);
grade = 0;              % ��ǰ����
o_g = 0;                % ��ǰ����
% С���ʼ��
ball = struct('x', 20, 'y', bottom, 'flag', 0);
% ���Ʊ���
bak = ['w', 'k'; 'k', 'w'];  % ��ʱ��仯����
title(sprintf('HI    %05d    %05d', r, grade), 'position',[120,60]);
axis equal
axis([0, max_length, 0, 55])          
set(gca,'xtick',[],'ytick',[],'xcolor','w','ycolor','w')
set(gca, 'color', 'w')
hold on
% ����С��
b = scatter(gca, ball.x, ball.y, 50, 'rs', 'filled');
% �����ϰ�
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
% ����ռ�
a = [pa1, pb1; pa2, pb2; pa3, pb3];
% ����ϰ���ʼ��
cube = [700, 40];
add = 0.5;
d = scatter(gca, cube(1), cube(2), 100, 'bd', 'filled');
% ��ؼ�����Ϣ
set(gcf, 'KeyPressFcn', @key)
% ���ö�ʱ���Ĳ���   fixedRate����һ��TimeFcn��ʼ�Ŷӵ��ڶ���TimeFcn��ʼ�Ŷ�֮���ʱ��Ϊ��ʱ����
ball_game = timer('ExecutionMode', 'FixedRate', 'Period', T, 'TimerFcn', @f); 
start(ball_game)
    function f(~, ~)
        % ��������ϰ�
        changdu = max_length + round(unifrnd(80, 150, 1));  % ����һ���ϰ��ľ���
        k = round(unifrnd(3, 5, 1, 1));                     % �ϰ��Ŀ��
        high = round(unifrnd(15, 20, 1, 1));                % �ϰ��ĸ߶�
        base = round(unifrnd(0, 35, 1, 1));                 % �ϰ��ĵײ�
        % �ж��ϰ��Ƿ���Է����ϰ�������
        if dis == 0 || dis < max_length
            barriers = [barriers; changdu, changdu + k, base, high + base];
            dis = changdu + k;
        end
        % �ж��ϰ��Ƿ񵽴�����ı߽�
        if barriers(1, 2) <= min_length
            barriers(1,:) = [];                             % ɾ����һ���ϰ�
        end
        if cube(1) < min_length       % ������ɷ���
            cube(1) = round(unifrnd(200, 400, 1));
            cube(2) = round(unifrnd(20, 30, 1));
        end
        % ÿ��ʱ�� �ƶ��ϰ�
        l = length(barriers(:, 1));
        barriers(:, 1) = barriers(:, 1) - n_add;
        barriers(:, 2) = barriers(:, 2) - n_add;
        % �ƶ�����
        cube(1) = cube(1) - add;
        % ������Զ����
        dis = barriers(l, 2);
        % �ж�С���Ƿ����ϰ���ײ 
        if ball.y < 2 || ball.y > 53 ...
            || ball.x <= barriers(1, 2) && ball.x >= barriers(1, 1) && ~(ball.y >= barriers(1, 3) && ball.y <= barriers(1, 4) ...
                || (ball.x > cube(1)-2.5 && ball.y > cube(2) - 2.5 && ball.x < cube(1) + 2.5 && ball.y < cube(2) + 2.5))
            if r == grade                                   % ���¼�¼
                record = fopen('record.txt', 'w');          % ���ļ�  ��ɾ����ԭ������
                fprintf(record, '%d', r);                   % д���µļ�¼
                fclose(record);                             % �ر��ļ�
            end
            soundsc(song2, fs)
            stop(ball_game)
            ButtonName = questdlg('GAME  OVER��', 'Gave Over', '����', '���¿�ʼ', '�ر���Ϸ', '����');
            switch ButtonName
                case '����'
                    % �ж�С���Ƿ����ϰ�������ϰ���ײ
                    if ball.x >= barriers(1, 2) || ball.x <= barriers(1, 1)
                        ball.y = 20;
                        bottom = ball.y;
                        tim = 0;
                        ball.flag = 0;
                    elseif (ball.x > cube(1)-2.5 && ball.y > cube(2) - 2.5 && ball.x < cube(1) + 2.5 && ball.y < cube(2) + 2.5)
                        cube(1) = cube(1) - 10;
                    else
                        barriers(1, 1) = barriers(1, 1) - 10;   % ���ϰ�ǰ��10  �ܿ�С��
                        barriers(1, 2) = barriers(1, 2) - 10;                   
                    end
                    % o_g = 0;
                    start(ball_game)
                case '�ر���Ϸ'
                    delete(ball_game)
                    close;
                    return
                case '���¿�ʼ'
                    delete(ball_game)
                    close;
                    m7_56_ballgame()
                    return
                otherwise
                    clear, clc, close all
                    return
            end
        end
        % С���ƶ�
        if ball.flag == 1
            tim = tim + space_t;
            % ����
            % t = 0:0.1:10;    v0 = 50/12;      g = 10/12;
            % y = v0.*t-0.5*g.*t.^2;
            % plot(t, y)
            ball.y = bottom + v0 * tim - 0.5 * g * tim^2;
        end
        % ���·���
        o_g = o_g + 1;
        grade = int16(o_g / 30);
        if grade > r
            r = grade;
        end
        % ���»�ͼ
        title(sprintf('HI    %05d    %05d', r, grade));
        set(b, 'XData', ball.x,  'YData', ball.y);  % С��
        set(d, 'XData', cube(1),  'YData', cube(2)); 
        temp = 0;
        if grade > 99
        temp = rem(grade/100, 2);
        end
        set(gca, 'color', bak(temp+1, 1))  % ÿ��100����ɫ��һ��
        for p = 1:l    % �ϰ�
            x1 = [barriers(p, 1), barriers(p, 2), barriers(p, 2), barriers(p, 1)];
            y1 = [0, 0, barriers(p, 3), barriers(p, 3)];
            x2 = [barriers(p, 1), barriers(p, 2), barriers(p, 2), barriers(p, 1)];
            y2 = [barriers(p, 4), barriers(p, 4), 55, 55];      
            set(a(p, 1),'XData', x1,  'YData', y1, 'FaceColor', bak(temp+1, 2)); 
            set(a(p, 2),'XData', x2,  'YData', y2, 'FaceColor', bak(temp+1, 2));
        end
    end
    function key(~,event)  % ������Ϣ����
        switch event.Key
            case 'space'   % ����С������
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
            case 'shift'  % ��ͣ
                stop(ball_game)
                flag = 1;
             otherwise
                return
        end
    end
  end