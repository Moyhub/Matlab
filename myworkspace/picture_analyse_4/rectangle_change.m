function [output,output1,output2] = rectangle_change(len,ctr_x,ctr_y,div,ang)
    img1=zeros(256,256);
    wid=len/div; 
    %旋转后的四个参数的坐标如下：
    left=floor(ctr_x-len/2);
    right=ceil(ctr_x+len/2);
    top=floor(ctr_y-wid/2);
    bottom=ceil(ctr_y+wid/2);
    img1(left:right,top:bottom)=1;
    img1=imrotate(img1,ang,'bilinear','crop');
    output=img1;
    img1=fftshift(DFT_2(img1));
    img2=log(abs(img1));
    output1=img2;
    img3=angle(img1);
    output2=img3;
end