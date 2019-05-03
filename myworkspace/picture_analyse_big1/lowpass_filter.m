function output = lowpass_filter(state)
    W_X = cos(2*state);
    W_Y = sin(2*state);
    %定义一个5*5的高斯滤波进行平滑操作
    w = fspecial('gaussian',5,4);
%   W_X = filter2(w,W_X);
%   W_Y = filter2(w,W_Y);
    W_X = imfilter(W_X,w,'conv');
    W_Y = imfilter(W_Y,w,'conv');
    output = 0.5*atan2(W_Y,W_X);          
end
    