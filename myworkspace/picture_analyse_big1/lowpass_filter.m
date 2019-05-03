function output = lowpass_filter(state)
    W_X = cos(2*state);
    W_Y = sin(2*state);
    %����һ��5*5�ĸ�˹�˲�����ƽ������
    w = fspecial('gaussian',5,4);
%   W_X = filter2(w,W_X);
%   W_Y = filter2(w,W_Y);
    W_X = imfilter(W_X,w,'conv');
    W_Y = imfilter(W_Y,w,'conv');
    output = 0.5*atan2(W_Y,W_X);          
end
    