function line = FirstMode(obj,x,y)

firstframe = readFrame(obj);
%%
% 记录下初始坐标并存入lines中
count = 1;
lines = [];
lines(count,:) = [x,y];
%%
frame = readFrame(obj);
while obj.CurrentTime<obj.Duration
%   对读入的每帧进行处理，结合上一帧的足球坐标（x,y），得到足球的分割前景图
    segment(frame,firstframe,x,y);
    count = count+1;
    if(count > 12 || x == 0 || y == 0)
        line = lines;
        break;
    end
    [x,y] = calcenter(ballground);
    lines(count,:) = [x,y];
    firstframe = frame;
    frame = readFrame(obj);
end
%%
    function segment(frame,firstframe,x,y)
        if(x~=0 && y~=0)
           h = 30;
           w = 30;
           bw = rgb2gray(firstframe);
           bw2 = rgb2gray(frame);
           mask = zeros(size(bw2));
           mask(y-h:y+h,x-w:x+w) = 1;
           ballground = mask&(abs(bw2-bw)>20);
           B = ones(2);
           ballground = imerode(ballground,B);
           ballground = imdilate(ballground,B);
        end
    end

    function [meanx,meany] = calcenter(I)
           [rows,cols] = size(I); 
           x = ones(rows,1)*[1:cols];
           y = [1:rows]'*ones(1,cols);   
           area = sum(sum(I)); 
           meanx = int16(sum(sum(I.*x))/area); 
           meany = int16(sum(sum(I.*y))/area);
    end
end