img = imread('binzhou.bmp');
img = im2double(img);

img1 = img;
%加椒盐噪声
r_rate = rand(size(img));%控制椒盐率
saltpepper = rand(size(img));%控制生成椒还是盐
p_index = uint8(r_rate<0.2).*uint8(saltpepper<0.5);
s_index = uint8(r_rate<0.2).*uint8(saltpepper>0.5);
img1(logical(s_index)) = 1; %在满足p_index处的值全部设置为0
img1(logical(p_index)) = 0;   %在满足s_index处的值全部设置为1

figure(2)
subplot(1,3,1);
imshow(img);title('原图','fontname','楷体','Color','r');
subplot(1,3,2);
imshow(img1);title('加入椒盐噪声后','fontname','楷体','Color','r');
%中值滤波
img2 = medfilter(img1);
img3 = medfilter(img2);
subplot(1,3,3);
imshow(img3);title('中值滤波后','fontname','楷体','Color','r'); 
   