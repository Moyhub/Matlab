function tracking(videoname)
% 这是基础任务的代码框架，你可以参考并完善它来实现足球的定位和追踪
% 你只须完成initial(), segment(), calcenter()和calspeed()三个函数，就可以实现基础任务的要求
% 需要说明的是，为了让代码更有鲁棒性（适应更多的足球射门视频），你需要了解整个框架并不断完善它
% 足球面积的测量和速度的计算部分请自行完成
% 
% 所有示例代码去除注释后，整体就可以运行了
% 但是示例代码的精度和鲁棒性都没有优化过
% 如有任何疑问，请随时联系我，让我们一起构建世界！
%
% 许展玮
% 2018.12.5

obj = VideoReader('0.mp4');
firstframe = readFrame(obj);
figure(1),imshow(firstframe);
title('点选球的中心点并回车')
[x,y] = initial();
%%
% 记录下初始坐标并存入lines中
count = 1;
lines = [];
lines(count,:) = [x,y];
%%
segs = [];
frame = readFrame(obj);
while obj.CurrentTime<obj.Duration
%   对读入的每帧进行处理，结合上一帧的足球坐标（x,y），得到足球的分割前景图
    ballground = segment(frame,firstframe,x,y);
%   根据足球前景图确定足球的中心
    [x,y] = calcenter(ballground);
%   记录下坐标存入lines中，并画图
%   记录下这一帧的足球前景图，并存入segs中
    count = count+1;
    hold on
    lines(count,:) = [x,y];
    plot(lines(:,1),lines(:,2),'r-');
    hold off
%   (这里只是实例，你可能需要更好地存储方式)
%    segs(count-1,:,:) = ballground;
    segs(1,:,:) = ballground;
%   滚动处理下一帧，直到结束
    firstframe = frame;
    frame = readFrame(obj);
end
%%
%   处理完每一帧后，根据保存的足球分割图集segs，结合一些先验知识，计算足球面积、估算球速等
    speed= calspeed(segs);
%%
%   下面是最终展示足球框的代码，可忽略
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
    title('红色为轨迹/白色为足球分割结果/蓝色为足球检测框')
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
%       你需要在这里完成足球点的初始化
%       示例代码
        [x,y] = ginput();
        x = int16(x);
        y = int16(y);
    end

    function ballground = segment(frame,firstframe,x,y)
%         你需要在这里完成每一帧的足球前景分割
%         示例代码
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
%         你需要在这里完成足球中心点的计算，根据前景图
%         示例代码
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
%         你需要在这里完成足球面积的计算和球速的估算
%         示例代码
        speed = 3;
    end
end