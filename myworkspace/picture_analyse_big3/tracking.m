function tracking(~)
% 这是基础任务的代码框架，你可以参考并完善它来实现足球的定位和追踪
% 你只须完成initial(), segment(), calcenter()和calspeed()三个函数，就可以实现基础任务的要求
% 需要说明的是，为了让代码更有鲁棒性（适应更多的足球射门视频），你需要了解整个框架并不断完善它
% 足球面积的测量和速度的计算部分请自行完成
% 许展玮
% 2018.12.5

%%%%%%%%%%%%%%%%本次作业我使用了背景减的算法%%%%%%%%%%%%%%%%%%%%%%%%%%
%为了算法快速运行，我已经将背景算好并储存，可以直接使用，也可以把GetGround函数取消注释，即可重新计算背景
%%%%%%%%%%%%%%%%ENDENDENDENDEND%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

obj = VideoReader('videos\1.mp4');     %更改目录
% obj_1 = VideoReader('videos\4.mp4'); %计算背景用
% obj_2 = VideoReader('videos\4.mp4');
obj_3 = VideoReader('videos\1.mp4');   %更改目录
firstframe = readFrame(obj);
figure(1),imshow(firstframe);
title('点选球的中心点并回车')
[x,y] = initial();
x_hand = x;
y_hand = y;
%%
% 记录下初始坐标并存入lines中
line = FirstMode(obj_3,x,y); %先验概率集合 line是先验概率
NAME = obj_3.Name;
Time = obj_3.FrameRate;
Time = 1/Time ;              %一帧多少秒
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
% BackGround = GetGround(obj_1,obj_2); %计算背景用
% save('Video_data\7','BackGround');
frame = readFrame(obj);
while obj.CurrentTime<obj.Duration
%   对读入的每帧进行处理，结合上一帧的足球坐标（x,y），得到足球的分割前景图
    ballground = segment(frame,firstframe,x,y);
    flag = flag + 1;
%   根据足球前景图确定足球的中心
    [x,y] = calcenter(ballground);
    if(x == 0 || y == 0)
        break;
    end
    [ball,x1,y1,r] = Segment_My(frame,x,y,line,flag,x_hand,y_hand,NAME);
    radii(count,:) = r(1);
    %优化分割，将源代码作为先验概率 
%   记录下坐标存入lines中，并画图
    count = count+1;
    lines_final(count,:) = [x1,y1];
    firstframe = frame;                   %   滚动处理下一帧，直到结束
    frame = readFrame(obj);
end
%% 统一画出曲线
    imshow(frame);
    lines_final_sec = zeros( size(lines_final,1)-6,2 );
    lines_final_sec = lines_final(1:size(lines_final,1) - 6,: );
    linefin = Fitting(lines_final_sec);
    hold on;
    plot(lines_final_sec(:,1),linefin,'r-');
    lines_final_tri(:,1) = lines_final_sec(:,1);
    lines_final_tri(:,2) = round(linefin);              %轨迹点
%%
%   处理完每一帧后，根据保存的足球分割图集segs，结合一些先验知识，计算足球面积、估算球速等
    [S_max,S_average,S] = calspeed(radii,lines_final_tri);
    S_max
    S_average
    %save('Speed_data\8','S');
%%
%   下面是最终展示足球框的代码，可忽略
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
    title('红色为轨迹%%%%足球分割结果和足球检测框为了动态显示，没在这里画出，可以根据README中的操作查看%%%')
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
%         你需要在这里完成足球点的初始化
%         示例代码
        [x,y] = ginput();
        x = int16(x);
        y = int16(y);
    end

    function ballground = segment(frame,firstframe,x,y)
%         你需要在这里完成每一帧的足球前景分割
%         示例代码
    if(NAME == '0.mp4')  %防止出现找不到球的情况，设置大一点
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
%         你需要在这里完成足球中心点的计算，根据前景图
%         示例代码
        [rows,cols] = size(I); 
        x = ones(rows,1)*[1:cols];
        y = [1:rows]'*ones(1,cols);   
        area = sum(sum(I)); 
        meanx = int16(sum(sum(I.*x))/area); 
        meany = int16(sum(sum(I.*y))/area);
    end
  
    function [speed_max,speed_average,UpdataV1]  = calspeed(radii,node)
%   四号足球直径19厘米，5号足球直径21.5厘米
%   示例代码
       radii_average = mean(radii(:));  %球的平均半径
       length = size(node,1);
       UpdataV = [];
       UpdataV1 = [];
       UpdataV2 = [];
       %这里分别求出每一个小段的距离  
       for ii = 1 : length - 1
         distance = norm(node(ii,:) - node(ii+1,:)) ;
         if(NAME == '0.mp4')  
             prop = (0.095)/radii_average;    %每个像素代表多少厘米
             UpdataV(ii,:) = (distance * prop)/Time;
         else
             prop = (0.1075)/radii_average;    %每个像素代表多少厘米
             UpdataV(ii,:) = (distance * prop)/Time;
         end
       end
       COUNT1 = 1;%去除最高点与最低点
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
       speed_average = mean(UpdataV1(:));       %平均速度
       speed_max = max(UpdataV1(:));            %最大速度
    end
end