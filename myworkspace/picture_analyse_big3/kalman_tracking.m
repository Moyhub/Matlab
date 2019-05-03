function kalman_tracking(~)

PATH = 'videos\0.mp4';
obj = VideoReader(PATH);
NAME = obj.Name;
[SEG,frame] = KalmanFilterForTracking(PATH,NAME);
firstframe = readFrame(obj);
Time = obj.FrameRate;
Time = 1/Time ;              %一帧多少秒
flag = 1;
count = 1;
radii = [];
lines_final = [];
%% 
if(NAME == '0.mp4' )
    A = -30;
    C = -8;
    D = 40
    E = 5;
    F = 30;
    H = 14;
elseif((NAME == '2.mp4')| (NAME == '6.mp4')|(NAME == '7.mp4'))
    A = 2;
    C = 2;
    D = 30;
    E = 36;
    F = 16;   
    H = 4.9;
else
    A = 2;
    C = 2;
    D = 40;
    E = 12;
    F = 10; 
    H = 4.9;
end
    for ss = E :size(SEG,1)
        [c,r] = imfindcircles(squeeze(SEG(ss,:,:)),[1,F]);  %取出分割图
        if(size(c,1) == 0)
            continue;
        else
            y2 = c(1,1);
            x2 = c(1,2);
            break;
        end
    end
    for ss = E : size(SEG,1)
        TEMP = squeeze(SEG(ss,:,:));
        TEMP1 = zeros(size(TEMP));
       % figure(1);imshow(TEMP);
        TEMP1(x2-D:x2+D,y2-D:y2+D) = TEMP(x2-D:x2+D,y2-D:y2+D);
       % figure(2); imshow(TEMP1);
        [c,r] = imfindcircles(TEMP1,[1,F]);  %找圆
        if(size(c,1) == 0)
            y2 = y2 + A;
            x2 = x2 + C;
            sum1 = 0;
            sum2 = 0;
            for tt = 1:size(TEMP1,1)
                for ttt = 1:size(TEMP1,2)
                    if(TEMP1(tt,ttt)~=0)
                        sum1 = tt + sum1;
                        sum2 = ttt + sum2;
                    end
                end
            end
            if(sum1 ~=0 && sum2~=0)
              x3 = sum1/sum(TEMP1(:));
              y3 = sum2/sum(TEMP1(:));
              lines_final(count,:) = [x3,y3];
              radii(count,:) = H;
              count = count + 1;
            end
            continue;
        else
            y2 = c(1,1);
            x2 = c(1,2);
            lines_final(count,:) = [x2,y2];
            radii(count,:) = r(1);
            count = count + 1;
        end
    end
%% 统一画出曲线
    figure(1);imshow(frame);
    lines_final_sec = zeros( size(lines_final,1),2 );
    lines_final_sec = lines_final(1:size(lines_final,1) - 6,: );
    linefin = Fitting(lines_final_sec);
    hold on;
    %其实发现实际的效果也不是很好，所以轨迹仍使用原来的
    name1 = [];
    name1 = char(name1);
    name1(1) = NAME(1);
    name1(2) = '.';
    name1(3) = 'm';
    name1(4) = 'a';
    name1(5) = 't';
%     lines_final_tri = cell2mat(struct2cell(load(name1)));
%     plot(lines_final_tri(:,1),lines_final_tri(:,2),'r-');
    %%若想看卡拉曼滤波结果,将上述两行注释，下面三行不注释
    plot(linefin,lines_final_sec(:,1),'r-');
    lines_final_tri(:,1) = lines_final_sec(:,1);
    lines_final_tri(:,2) = round(linefin);              %轨迹点
%%
%   处理完每一帧后，根据保存的足球分割图集segs，结合一些先验知识，计算足球面积、估算球速等
    [S_max,S_average,S] = calspeed(radii,lines_final_tri);
    S_max
    S_average
    %save('Video_Kalman_data\7','S');
%%
%   下面是最终展示足球框的代码，可忽略
    h = 20;
    w = 20;
    mask = zeros(size(frame));
    [m,n] = size(lines_final_tri);
    y = lines_final_tri(m,2);
    x = lines_final_tri(m,1);
    mask(y-h:y+h,x-w:x+w) = 1;
    hold on
    title('红色为轨迹%%%%足球分割结果和足球检测框为了动态显示，没在这里画出，可以根据README中的操作查看%%%')
%%
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
       COUNT1 = 1;
       for k = 1: size(UpdataV,1)
           if(UpdataV(k) > 0.5  && UpdataV(k) < 5)
               UpdataV1(COUNT1,:) = UpdataV(k);
               COUNT1 = COUNT1 + 1;
           end
       end
       speed_average = mean(UpdataV1(:));       %平均速度
       speed_max = max(UpdataV1(:));            %最大速度
    end
end