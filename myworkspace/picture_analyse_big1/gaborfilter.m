function evenFilter = gaborfilter(state,dis)
 state = state*180/pi;
 a=5;
 sigmax = a;  
 sigmay = a*1.7;         %根据人眼观看效果，将sigmay = 1.7 * sigmax
 [x,y] = meshgrid(-5:5); %定义滤波器大小
 evenFilter = exp(-(x.^2/sigmax^2 + y.^2/sigmay^2)/2).*cos(2*pi*dis*x); 
 evenFilter = imrotate(evenFilter, state , 'bilinear','crop');
%  Eim = filter2(evenFilter,im);   % Even filter result 
%  gabor = Eim;
%  end
    