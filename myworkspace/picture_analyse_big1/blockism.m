function [output,output1] = blockism(img,i,j)
%600*800��ͼƬ��ʾ ����ߣ�Ҳ���ǿ�600����800��
%��matlab sizeȡ�����С��У��� ��800����600��
%��ͼ����ϰ�ɫ��Ե
  [m,n] = size(img);
  image_1 = ones(m+24,n+24);
  image_1(13:m+12,13:n+12) = img;  
  %output = image_1;
  image_temp = zeros(33,33);
  %�鵽ԭͼ��ԭ��%��m+12,n+12Ϊԭ��
  i=i+12;
  j=j+12;
  %��DFT
  image_temp = image_1(i-16:i+16,j-16:j+16);
  img1 = fftshift(fft2(image_temp));
  img3 = abs(img1);
  %img2 = zeros(9);
  %img2 = img3(i-4:i+4,j-4:j+4);
  %����������
  output = img3;
  output1 = angle(img1);
  
end
