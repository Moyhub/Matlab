function output  = gradients(img)
    %����sobel����ģ��
    %���ģ��
    hx = [1,0,-1;2,0,-2;1,0,-1];
    hy =hx';
    %����ˮƽ������ݶ�,�õ�ÿ�����ص�ˮƽ�ݶȺ���ֱ�ݶ�
    gradx = filter2(hx,img,'same');
    grady = filter2(hy,img,'same');
    %�������ķ���
    gradxx = gradx.^2;
    gradyy = grady.^2;
    gradxy = gradx.*grady;
    %��˹�˲�
    filter_1 = fspecial('gaussian',14,3);
    gradxx = filter2(filter_1,gradxx); 
    gradyy = filter2(filter_1,gradyy);
    gradxy = 2*filter2(filter_1,gradxy);
    
    %�Ƕ� +eps�Ƿ�ֹ����0���
    output =0.5*atan2(gradxy,(gradxx-gradyy+eps))+0.5*pi;
end
    
            
    
    