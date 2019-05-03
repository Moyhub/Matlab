%% 此部分代码是对JPEG的直流成分进行LPC，对预测误差进行霍夫曼编码

%DC.mat是我直接从老师上课JPEG压缩例子中取出的,DC_10表示quality=10，DC_1 表示quality=1
IMG_DC = cell2mat(struct2cell(load('DC_10.mat'))); 
%IMG_Compression = im2jpeg(IMG_Origin,1)
%IMG_DC = DC_Get(IMG_Origin);
%IMG_DC = double(IMG_DC)
e = im2lpc(IMG_DC);                %无损预测编码，返回预测误差
figure(1);
subplot(1,2,1);histogram(IMG_DC(:));title('直流成分直方图');
subplot(1,2,2);histogram(e(:));title('预测误差直方图');
[symbols,prob] = prob4huffman(e);  %返回的概率和区间
dict = huffmandict(symbols,prob);  %对误差的像素区间和概率生成的霍夫曼字典树,dict是N*2维元胞，第一维是像素值，第二维是编码
hcode = huffmanenco(e(:),dict);    %对图像进行编码
[huffmanCode,huffmanCodeLen] = huffmanDouble2Bin(hcode);%将二进制数转成10进制数，和二进制的位长

cr = imratio(uint8(IMG_DC), huffmanCode)               %计算压缩比

hcode = huffmanBin2Double(huffmanCode,huffmanCodeLen); %将十进制转换成二进制
e2 = huffmandeco(hcode, dict);                         %解码
e2 = reshape(e2, size(IMG_DC,1), size(IMG_DC,2));      %得到预测误差图
g = lpc2im(e2);                                        %从预测误差图得到原图

rmse = CompareImages(IMG_DC, g)                        % = 0 说明无损 计算均方误差

figure(2);
subplot(1,2,1);imshow(e,[]);title('压缩前的预测误差');
subplot(1,2,2);imshow(e2,[]);title('解压缩后的预测误差');
figure(3);
subplot(1,2,1);imshow(IMG_DC,[]);title('压缩前直流成分图');  %加[] 适用于double类型
subplot(1,2,2);imshow(g,[]);title('解压缩后的直流成分图');
%% 彩色图像压缩 对RGB通道分别压缩
IMGRGB = imread('lena_std.tif');
IMG_R = IMGRGB(:,:,1);
IMG_G = IMGRGB(:,:,2);
IMG_B = IMGRGB(:,:,3);
%对于quality = 1时  
cr = im2jpeg(IMG_R,1);
cg = im2jpeg(IMG_G,1);
cb = im2jpeg(IMG_B,1);
cr1 = jpeg2im(cr);
cg1 = jpeg2im(cg);
cb1 = jpeg2im(cb);
RGB_HUI_1(:,:,1) = cr1;
RGB_HUI_1(:,:,2) = cg1;
RGB_HUI_1(:,:,3) = cb1;
compression_ratio1 = (imratio(IMG_R, cr) + imratio(IMG_G,cg) + imratio(IMG_B,cb))/3
rmse1 = CompareImages(IMGRGB, RGB_HUI_1)
figure(4);
subplot(2,2,1);imshow(RGB_HUI_1);title('当quality = 1时,恢复图如下');
%对于quality = 5时
cr = im2jpeg(IMG_R,5);
cg = im2jpeg(IMG_G,5);
cb = im2jpeg(IMG_B,5);
cr2 = jpeg2im(cr);
cg2 = jpeg2im(cg);
cb2 = jpeg2im(cb);
RGB_HUI_5(:,:,1) = cr2;
RGB_HUI_5(:,:,2) = cg2;
RGB_HUI_5(:,:,3) = cb2;
compression_ratio2 = (imratio(IMG_R, cr) + imratio(IMG_G,cg) + imratio(IMG_B,cb))/3
rmse2 = CompareImages(IMGRGB, RGB_HUI_5)
subplot(2,2,2);imshow(RGB_HUI_5);title('当quality = 5时,恢复图如下');
%对于quality = 10时  
cr = im2jpeg(IMG_R,10);
cg = im2jpeg(IMG_G,10);
cb = im2jpeg(IMG_B,10);
cr1 = jpeg2im(cr);
cg1 = jpeg2im(cg);
cb1 = jpeg2im(cb);
RGB_HUI_10(:,:,1) = cr1;
RGB_HUI_10(:,:,2) = cg1;
RGB_HUI_10(:,:,3) = cb1;
compression_ratio3 = (imratio(IMG_R, cr) + imratio(IMG_G,cg) + imratio(IMG_B,cb))/3
rmse3 = CompareImages(IMGRGB, RGB_HUI_10)
subplot(2,2,3);imshow(RGB_HUI_10);title('当quality = 10时,恢复图如下');
%对于quality = 20时
cr = im2jpeg(IMG_R,20);
cg = im2jpeg(IMG_G,20);
cb = im2jpeg(IMG_B,20);
cr2 = jpeg2im(cr);
cg2 = jpeg2im(cg);
cb2 = jpeg2im(cb);
RGB_HUI_20(:,:,1) = cr2;
RGB_HUI_20(:,:,2) = cg2;
RGB_HUI_20(:,:,3) = cb2;
compression_ratio4 = (imratio(IMG_R, cr) + imratio(IMG_G,cg) + imratio(IMG_B,cb))/3
rmse4 = CompareImages(IMGRGB, RGB_HUI_20)
subplot(2,2,4);imshow(RGB_HUI_20);title('当quality = 20时,恢复图如下');
%% 将RGB转换为YCbCr空间后计算压缩比
IMGYCBCR = rgb2ycbcr(IMGRGB);
YCBCR_Y = IMGYCBCR(:,:,1);
YCBCR_CB = IMGYCBCR(:,:,2);
YCBCR_CR = IMGYCBCR(:,:,3);
figure(5);
subplot(2,2,1);imshow(IMGYCBCR);title('IMGYCBCR图');
subplot(2,2,2);imshow(YCBCR_Y);title('Y通道图');
subplot(2,2,3);imshow(YCBCR_CB);title('Cb通道图');
subplot(2,2,4);imshow(YCBCR_CR);title('Cr通道图');
%对后两个通道进行缩小，即每隔一个点取一个
CB = zeros(size(YCBCR_CB,1)/2 , size(YCBCR_CB,2)/2);
CR = zeros(size(YCBCR_CR,1)/2 , size(YCBCR_CR,2)/2);
s = 1; t =1;
for i = 1:2:size(YCBCR_CB,1)
    for j = 1:2:size(YCBCR_CB,2)
        CB(s,t) = YCBCR_CB(i,j);
        t = t+1;
    end
    t= 1;
    s=s+1;
end
s = 1;t=1;
for i = 1:2:size(YCBCR_CR,1)
    for j = 1:2:size(YCBCR_CR,2)
        CR(s,t) = YCBCR_CR(i,j);
        t = t+1;
    end
    t= 1;
    s=s+1;
end
%得到的数据仅以10为例，其他的不予显示
y = im2jpeg(YCBCR_Y,10);
cb = im2jpeg(uint8(CB),10);
cr = im2jpeg(uint8(CR),10);%压缩

y1 = jpeg2im(y);  
cb1 = jpeg2im(cb);
cr1 = jpeg2im(cr);  %恢复
cb1 = imresize(cb1,2,'bicubic');
cr1 = imresize(cr1,2,'bicubic');
YCrCb_HUI(:,:,1) = y1;
YCrCb_HUI(:,:,2) = cb1;
YCrCb_HUI(:,:,3) = cr1;
RGB_HUI = ycbcr2rgb(YCrCb_HUI);

compression_ratio5y = imratio(YCBCR_Y, y)
compression_ratio5b = imratio(YCBCR_CB,cb)
compression_ratio5r = imratio(YCBCR_CR,cr)
rmse5y = CompareImages(YCBCR_Y, y1)
rmse5b = CompareImages(YCBCR_CB, cb1) 
rmse5r = CompareImages(YCBCR_CR, cr1)
Compress = (compression_ratio5y +compression_ratio5b +compression_ratio5r)/3
rmse = CompareImages(IMGRGB,RGB_HUI)
figure(6);
subplot(2,2,3);imshow(RGB_HUI);title('当quality=10时');
y = im2jpeg(YCBCR_Y,5);
cb = im2jpeg(uint8(CB),5);
cr = im2jpeg(uint8(CR),5);%压缩
y1 = jpeg2im(y);  
cb1 = jpeg2im(cb);
cr1 = jpeg2im(cr);  %恢复
cb1 = imresize(cb1,2,'bicubic');
cr1 = imresize(cr1,2,'bicubic');
YCrCb_HUI(:,:,1) = y1;
YCrCb_HUI(:,:,2) = cb1;
YCrCb_HUI(:,:,3) = cr1;
RGB_HUI = ycbcr2rgb(YCrCb_HUI);
subplot(2,2,2);imshow(RGB_HUI);title('当quality=5时');
y = im2jpeg(YCBCR_Y,1);
cb = im2jpeg(uint8(CB),1);
cr = im2jpeg(uint8(CR),1);%压缩
y1 = jpeg2im(y);  
cb1 = jpeg2im(cb);
cr1 = jpeg2im(cr);  %恢复
cb1 = imresize(cb1,2,'bicubic');
cr1 = imresize(cr1,2,'bicubic');
YCrCb_HUI(:,:,1) = y1;
YCrCb_HUI(:,:,2) = cb1;
YCrCb_HUI(:,:,3) = cr1;
RGB_HUI = ycbcr2rgb(YCrCb_HUI);
subplot(2,2,1);imshow(RGB_HUI);title('当quality=1时');
y = im2jpeg(YCBCR_Y,20);
cb = im2jpeg(uint8(CB),20);
cr = im2jpeg(uint8(CR),20);%压缩
y1 = jpeg2im(y);  
cb1 = jpeg2im(cb);
cr1 = jpeg2im(cr);  %恢复
cb1 = imresize(cb1,2,'bicubic');
cr1 = imresize(cr1,2,'bicubic');
YCrCb_HUI(:,:,1) = y1;
YCrCb_HUI(:,:,2) = cb1;
YCrCb_HUI(:,:,3) = cr1;
RGB_HUI = ycbcr2rgb(YCrCb_HUI);
subplot(2,2,4);imshow(RGB_HUI);title('当quality=20时');







