function [output1,output2,output3,output4] = gauss(sigma)
   X=1:1:256;
   Y=X';
   img2=1/(2*pi*sigma*sigma)*exp(-1/2*(((X-128)/sigma).^2+((Y-128)/sigma).^2));
   img1=img2/max(max(img2));
   f=DFT_2(img1);
   f=fftshift(f);                 %使傅里叶变换的中心变为图像中心
   img3=log(abs(f));              %幅度
   img4=(angle(f)*180/pi);        %相位
   img5=angle(f);
   output1=img1;
   output2=img3;
   output3=img4;
   output4=img5;
end