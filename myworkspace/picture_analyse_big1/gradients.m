function output  = gradients(img)
    %定义sobel算子模板
    %卷积模板
    hx = [1,0,-1;2,0,-2;1,0,-1];
    hy =hx';
    %计算水平方向的梯度,得到每个像素的水平梯度和竖直梯度
    gradx = filter2(hx,img,'same');
    grady = filter2(hy,img,'same');
    %估算中心方向
    gradxx = gradx.^2;
    gradyy = grady.^2;
    gradxy = gradx.*grady;
    %高斯滤波
    filter_1 = fspecial('gaussian',14,3);
    gradxx = filter2(filter_1,gradxx); 
    gradyy = filter2(filter_1,gradyy);
    gradxy = 2*filter2(filter_1,gradxy);
    
    %角度 +eps是防止出现0情况
    output =0.5*atan2(gradxy,(gradxx-gradyy+eps))+0.5*pi;
end
    
            
    
    