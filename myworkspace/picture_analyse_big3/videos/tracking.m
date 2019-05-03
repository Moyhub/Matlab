function tracking(videoname)
% ���ǻ�������Ĵ����ܣ�����Բο�����������ʵ������Ķ�λ��׷��
% ��ֻ�����initial(), segment(), calcenter()��calspeed()�����������Ϳ���ʵ�ֻ��������Ҫ��
% ��Ҫ˵�����ǣ�Ϊ���ô������³���ԣ���Ӧ���������������Ƶ��������Ҫ�˽�������ܲ�����������
% ��������Ĳ������ٶȵļ��㲿�����������
% 
% ����ʾ������ȥ��ע�ͺ�����Ϳ���������
% ����ʾ������ľ��Ⱥ�³���Զ�û���Ż���
% �����κ����ʣ�����ʱ��ϵ�ң�������һ�𹹽����磡
%
% ��չ��
% 2018.12.5

obj = VideoReader('0.mp4');
firstframe = readFrame(obj);
figure(1),imshow(firstframe);
title('��ѡ������ĵ㲢�س�')
[x,y] = initial();
%%
% ��¼�³�ʼ���겢����lines��
count = 1;
lines = [];
lines(count,:) = [x,y];
%%
segs = [];
frame = readFrame(obj);
while obj.CurrentTime<obj.Duration
%   �Զ����ÿ֡���д��������һ֡���������꣨x,y�����õ�����ķָ�ǰ��ͼ
    ballground = segment(frame,firstframe,x,y);
%   ��������ǰ��ͼȷ�����������
    [x,y] = calcenter(ballground);
%   ��¼���������lines�У�����ͼ
%   ��¼����һ֡������ǰ��ͼ��������segs��
    count = count+1;
    hold on
    lines(count,:) = [x,y];
    plot(lines(:,1),lines(:,2),'r-');
    hold off
%   (����ֻ��ʵ�����������Ҫ���õش洢��ʽ)
%    segs(count-1,:,:) = ballground;
    segs(1,:,:) = ballground;
%   ����������һ֡��ֱ������
    firstframe = frame;
    frame = readFrame(obj);
end
%%
%   ������ÿһ֡�󣬸��ݱ��������ָ�ͼ��segs�����һЩ����֪ʶ����������������������ٵ�
    speed= calspeed(segs);
%%
%   ����������չʾ�����Ĵ��룬�ɺ���
    h = 20;
    w = 20;
    bw2 = rgb2gray(frame);
    mask = zeros(size(bw2));
    mask(y-h:y+h,x-w:x+w) = 1;
    ballground = mask&((bw2>200)|abs(bw2-bw)>20);
    B = ones(3);
    ballground = imerode(ballground,B);
    ballground = imdilate(ballground,B);
    for i = 1:3
        per_frame = frame(:,:,i);
        per_frame(ballground>0) = 255;
        frame(:,:,i)= per_frame;
    end
    imshow(frame)
    [x,y] = calcenter(ballground);
    count = count+1;
    hold on
    lines(count,:) = [x,y];
    plot(lines(:,1),lines(:,2),'r-');
    [x_min,x_max,y_min,y_max] = calbbox(ballground);
    draw_lines(x_min,x_max,y_min,y_max)
    hold on
    title('��ɫΪ�켣/��ɫΪ����ָ���/��ɫΪ�������')
    function draw_lines(x_min,x_max,y_min,y_max)
        hold on
        liness = [x_min,x_min,x_max,x_max,x_min;y_min,y_max,y_max,y_min,y_min];
        plot(liness(1,:),liness(2,:))
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
%       ����Ҫ��������������ĳ�ʼ��
%       ʾ������
        [x,y] = ginput();
        x = int16(x);
        y = int16(y);
    end

    function ballground = segment(frame,firstframe,x,y)
%         ����Ҫ���������ÿһ֡������ǰ���ָ�
%         ʾ������
        h = 35;
        w = 35;
        bw = rgb2gray(firstframe);
        bw2 = rgb2gray(frame);
        mask = zeros(size(bw2));
        mask(y-h:y+h,x-w:x+w) = 1;
        ballground = mask&(abs(bw2-bw)>20);
        B = ones(2);
        ballground = imerode(ballground,B);
        ballground = imdilate(ballground,B);
       % figure(2);imshow(ballground);
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
%         if(meanx == 0 || meany == 0)
%             [meanx,meany] = ginput();
%         end
    end
  
    function speed = calspeed(segs)
%         ����Ҫ�����������������ļ�������ٵĹ���
%         ʾ������
        speed = 3;
    end
end