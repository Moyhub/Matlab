function background = GetGround(obj_1,obj_2)  %获取背景图
    value= get(obj_2,{'Width','Height','NumberOfFrames'});
    n = value{1,1};
    m = value{1,2};
    FrameNum = value{1,3};
    
    MaxTimes = zeros(m,n);
    Frames = cell(1,FrameNum);
    temp = zeros(1,FrameNum);
    frame = read(obj_1);
    
    for i = 1:FrameNum
        Frames{1,i} = rgb2gray(frame(:,:,:,i) );
        Frames{1,i} = im2double(Frames{1,i});   %是im2double 不是 double
    end
    for i = 1:m
        for j = 1: n
            for k = 1:FrameNum
                temp(1,k) = Frames{1,k}(i,j);  
            end
            MaxTimes(i,j) = mode(temp);
        end
    end
    background = MaxTimes;
                
