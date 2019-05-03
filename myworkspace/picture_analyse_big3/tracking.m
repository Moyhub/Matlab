function tracking(~)
% ���ǻ�������Ĵ����ܣ�����Բο�����������ʵ������Ķ�λ��׷��
% ��ֻ�����initial(), segment(), calcenter()��calspeed()�����������Ϳ���ʵ�ֻ��������Ҫ��
% ��Ҫ˵�����ǣ�Ϊ���ô������³���ԣ���Ӧ���������������Ƶ��������Ҫ�˽�������ܲ�����������
% ��������Ĳ������ٶȵļ��㲿�����������
% ��չ��
% 2018.12.5

%%%%%%%%%%%%%%%%������ҵ��ʹ���˱��������㷨%%%%%%%%%%%%%%%%%%%%%%%%%%
%Ϊ���㷨�������У����Ѿ���������ò����棬����ֱ��ʹ�ã�Ҳ���԰�GetGround����ȡ��ע�ͣ��������¼��㱳��
%%%%%%%%%%%%%%%%ENDENDENDENDEND%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

obj = VideoReader('videos\1.mp4');     %����Ŀ¼
% obj_1 = VideoReader('videos\4.mp4'); %���㱳����
% obj_2 = VideoReader('videos\4.mp4');
obj_3 = VideoReader('videos\1.mp4');   %����Ŀ¼
firstframe = readFrame(obj);
figure(1),imshow(firstframe);
title('��ѡ������ĵ㲢�س�')
[x,y] = initial();
x_hand = x;
y_hand = y;
%%
% ��¼�³�ʼ���겢����lines��
line = FirstMode(obj_3,x,y); %������ʼ��� line���������
NAME = obj_3.Name;
Time = obj_3.FrameRate;
Time = 1/Time ;              %һ֡������
flag = 1;
count = 1;
radii = [];
lines_final = [];
lines(count,:) = [x,y];
%%
segs = [];
[ball,x1,y1,r] = Segment_My(firstframe,x,y,line,flag,x_hand,y_hand,NAME);
lines_final(count,:) = [x1,y1];
radii(count,:) = r(1);
% BackGround = GetGround(obj_1,obj_2); %���㱳����
% save('Video_data\7','BackGround');
frame = readFrame(obj);
while obj.CurrentTime<obj.Duration
%   �Զ����ÿ֡���д��������һ֡���������꣨x,y�����õ�����ķָ�ǰ��ͼ
    ballground = segment(frame,firstframe,x,y);
    flag = flag + 1;
%   ��������ǰ��ͼȷ�����������
    [x,y] = calcenter(ballground);
    if(x == 0 || y == 0)
        break;
    end
    [ball,x1,y1,r] = Segment_My(frame,x,y,line,flag,x_hand,y_hand,NAME);
    radii(count,:) = r(1);
    %�Ż��ָ��Դ������Ϊ������� 
%   ��¼���������lines�У�����ͼ
    count = count+1;
    lines_final(count,:) = [x1,y1];
    firstframe = frame;                   %   ����������һ֡��ֱ������
    frame = readFrame(obj);
end
%% ͳһ��������
    imshow(frame);
    lines_final_sec = zeros( size(lines_final,1)-6,2 );
    lines_final_sec = lines_final(1:size(lines_final,1) - 6,: );
    linefin = Fitting(lines_final_sec);
    hold on;
    plot(lines_final_sec(:,1),linefin,'r-');
    lines_final_tri(:,1) = lines_final_sec(:,1);
    lines_final_tri(:,2) = round(linefin);              %�켣��
%%
%   ������ÿһ֡�󣬸��ݱ��������ָ�ͼ��segs�����һЩ����֪ʶ����������������������ٵ�
    [S_max,S_average,S] = calspeed(radii,lines_final_tri);
    S_max
    S_average
    %save('Speed_data\8','S');
%%
%   ����������չʾ�����Ĵ��룬�ɺ���
    h = 20;
    w = 20;
    mask = zeros(size(ball));
    [m,n] = size(lines_final_tri);
    y = lines_final_sec(m,2);
    x = lines_final_sec(m,1);
    mask(y-h:y+h,x-w:x+w) = 1;
    
%     ballground = mask&((bw2>200)|abs(bw2-bw)>20);
%     B = ones(3);
%     ballground = imerode(ballground,B);
%     ballground = imdilate(ballground,B);
    for i = 1:3
        per_frame = frame(:,:,i);
        per_frame(ballground>0) = 255;
        frame(:,:,i)= per_frame;
    end
    [x_min,x_max,y_min,y_max] = calbbox(ballground);
    draw_lines(x_min,x_max,y_min,y_max)
    hold on
    title('��ɫΪ�켣%%%%����ָ������������Ϊ�˶�̬��ʾ��û�����ﻭ�������Ը���README�еĲ����鿴%%%')
    function draw_lines(x_min,x_max,y_min,y_max)
        hold on
        liness = [x_min,x_min,x_max,x_max,x_min;y_min,y_max,y_max,y_min,y_min];
       % plot(liness(1,:),liness(2,:))
        hold off;
    end
  function [x_min,x_max,y_min,y_max] = calbbox(I)
        [rows,cols] = size(I); 
        x = ones(rows,1)*[1:cols];
        y = [1:rows]'*ones(1,cols);   
        rows = I.*x;
        x_max = max(rows(:))+2;
        rows(rows==0) = x_max;
        x_min = min(rows(:))-2;
        rows = I.*y;
        y_max = max(rows(:))+2;
        rows(rows==0) = y_max;
        y_min = min(rows(:))-2;
  end
%%

    function [x,y] = initial()
%         ����Ҫ��������������ĳ�ʼ��
%         ʾ������
        [x,y] = ginput();
        x = int16(x);
        y = int16(y);
    end

    function ballground = segment(frame,firstframe,x,y)
%         ����Ҫ���������ÿһ֡������ǰ���ָ�
%         ʾ������
    if(NAME == '0.mp4')  %��ֹ�����Ҳ��������������ô�һ��
        h = 35;
        w = 35;
    else
        h = 25;
        w = 25;
    end
        bw = rgb2gray(firstframe);
        bw2 = rgb2gray(frame);
        mask = zeros(size(bw2));
        mask(y-h:y+h,x-w:x+w) = 1;
        ballground = mask&(abs(bw2-bw)>20);
        B = ones(2);
        ballground = imerode(ballground,B);
        ballground = imdilate(ballground,B);
    end

    function [meanx,meany] = calcenter(I)
%         ����Ҫ����������������ĵ�ļ��㣬����ǰ��ͼ
%         ʾ������
        [rows,cols] = size(I); 
        x = ones(rows,1)*[1:cols];
        y = [1:rows]'*ones(1,cols);   
        area = sum(sum(I)); 
        meanx = int16(sum(sum(I.*x))/area); 
        meany = int16(sum(sum(I.*y))/area);
    end
  
    function [speed_max,speed_average,UpdataV1]  = calspeed(radii,node)
%   �ĺ�����ֱ��19���ף�5������ֱ��21.5����
%   ʾ������
       radii_average = mean(radii(:));  %���ƽ���뾶
       length = size(node,1);
       UpdataV = [];
       UpdataV1 = [];
       UpdataV2 = [];
       %����ֱ����ÿһ��С�εľ���  
       for ii = 1 : length - 1
         distance = norm(node(ii,:) - node(ii+1,:)) ;
         if(NAME == '0.mp4')  
             prop = (0.095)/radii_average;    %ÿ�����ش����������
             UpdataV(ii,:) = (distance * prop)/Time;
         else
             prop = (0.1075)/radii_average;    %ÿ�����ش����������
             UpdataV(ii,:) = (distance * prop)/Time;
         end
       end
       COUNT1 = 1;%ȥ����ߵ�����͵�
       for k = 1: size(UpdataV,1)
           if(UpdataV(k) > 0.5  && UpdataV(k) < 5)
               UpdataV1(COUNT1,:) = UpdataV(k);
               COUNT1 = COUNT1 + 1;
           end
       end
       kkk = 0;
       sum = 0;
       sss = 1;
       for k1 = 1:size(UpdataV1,1)
           sum  = UpdataV1(k1) + sum;
           kkk = kkk+1;
           if(kkk == 5)
              UpdataV2(sss,:) = sum/5;
           end
       end
       speed_average = mean(UpdataV1(:));       %ƽ���ٶ�
       speed_max = max(UpdataV1(:));            %����ٶ�
    end
end