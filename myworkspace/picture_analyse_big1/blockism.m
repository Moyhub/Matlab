function [output,output1] = blockism(img,i,j)
%600*800的图片表示 宽×高，也就是宽600，高800；
%而matlab size取得是行×列，即 行800；列600；
%给图像加上白色外缘
  [m,n] = size(img);
  image_1 = ones(m+24,n+24);
  image_1(13:m+12,13:n+12) = img;  
  %output = image_1;
  image_temp = zeros(33,33);
  %归到原图像原点%以m+12,n+12为原点
  i=i+12;
  j=j+12;
  %做DFT
  image_temp = image_1(i-16:i+16,j-16:j+16);
  img1 = fftshift(fft2(image_temp));
  img3 = abs(img1);
  %img2 = zeros(9);
  %img2 = img3(i-4:i+4,j-4:j+4);
  %输出其幅度谱
  output = img3;
  output1 = angle(img1);
  
end
