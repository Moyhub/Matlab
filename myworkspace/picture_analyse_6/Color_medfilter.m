img = imread('binzhou.bmp');
img = im2double(img);

img1 = img;
%�ӽ�������
r_rate = rand(size(img));%���ƽ�����
saltpepper = rand(size(img));%�������ɽ�������
p_index = uint8(r_rate<0.2).*uint8(saltpepper<0.5);
s_index = uint8(r_rate<0.2).*uint8(saltpepper>0.5);
img1(logical(s_index)) = 1; %������p_index����ֵȫ������Ϊ0
img1(logical(p_index)) = 0;   %������s_index����ֵȫ������Ϊ1

figure(2)
subplot(1,3,1);
imshow(img);title('ԭͼ','fontname','����','Color','r');
subplot(1,3,2);
imshow(img1);title('���뽷��������','fontname','����','Color','r');
%��ֵ�˲�
img2 = medfilter(img1);
img3 = medfilter(img2);
subplot(1,3,3);
imshow(img3);title('��ֵ�˲���','fontname','����','Color','r'); 
   