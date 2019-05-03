%% �˲��ִ����Ƕ�JPEG��ֱ���ɷֽ���LPC����Ԥ�������л���������

%DC.mat����ֱ�Ӵ���ʦ�Ͽ�JPEGѹ��������ȡ����,DC_10��ʾquality=10��DC_1 ��ʾquality=1
IMG_DC = cell2mat(struct2cell(load('DC_10.mat'))); 
%IMG_Compression = im2jpeg(IMG_Origin,1)
%IMG_DC = DC_Get(IMG_Origin);
%IMG_DC = double(IMG_DC)
e = im2lpc(IMG_DC);                %����Ԥ����룬����Ԥ�����
figure(1);
subplot(1,2,1);histogram(IMG_DC(:));title('ֱ���ɷ�ֱ��ͼ');
subplot(1,2,2);histogram(e(:));title('Ԥ�����ֱ��ͼ');
[symbols,prob] = prob4huffman(e);  %���صĸ��ʺ�����
dict = huffmandict(symbols,prob);  %��������������͸������ɵĻ������ֵ���,dict��N*2άԪ������һά������ֵ���ڶ�ά�Ǳ���
hcode = huffmanenco(e(:),dict);    %��ͼ����б���
[huffmanCode,huffmanCodeLen] = huffmanDouble2Bin(hcode);%����������ת��10���������Ͷ����Ƶ�λ��

cr = imratio(uint8(IMG_DC), huffmanCode)               %����ѹ����

hcode = huffmanBin2Double(huffmanCode,huffmanCodeLen); %��ʮ����ת���ɶ�����
e2 = huffmandeco(hcode, dict);                         %����
e2 = reshape(e2, size(IMG_DC,1), size(IMG_DC,2));      %�õ�Ԥ�����ͼ
g = lpc2im(e2);                                        %��Ԥ�����ͼ�õ�ԭͼ

rmse = CompareImages(IMG_DC, g)                        % = 0 ˵������ ����������

figure(2);
subplot(1,2,1);imshow(e,[]);title('ѹ��ǰ��Ԥ�����');
subplot(1,2,2);imshow(e2,[]);title('��ѹ�����Ԥ�����');
figure(3);
subplot(1,2,1);imshow(IMG_DC,[]);title('ѹ��ǰֱ���ɷ�ͼ');  %��[] ������double����
subplot(1,2,2);imshow(g,[]);title('��ѹ�����ֱ���ɷ�ͼ');
%% ��ɫͼ��ѹ�� ��RGBͨ���ֱ�ѹ��
IMGRGB = imread('lena_std.tif');
IMG_R = IMGRGB(:,:,1);
IMG_G = IMGRGB(:,:,2);
IMG_B = IMGRGB(:,:,3);
%����quality = 1ʱ  
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
subplot(2,2,1);imshow(RGB_HUI_1);title('��quality = 1ʱ,�ָ�ͼ����');
%����quality = 5ʱ
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
subplot(2,2,2);imshow(RGB_HUI_5);title('��quality = 5ʱ,�ָ�ͼ����');
%����quality = 10ʱ  
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
subplot(2,2,3);imshow(RGB_HUI_10);title('��quality = 10ʱ,�ָ�ͼ����');
%����quality = 20ʱ
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
subplot(2,2,4);imshow(RGB_HUI_20);title('��quality = 20ʱ,�ָ�ͼ����');
%% ��RGBת��ΪYCbCr�ռ�����ѹ����
IMGYCBCR = rgb2ycbcr(IMGRGB);
YCBCR_Y = IMGYCBCR(:,:,1);
YCBCR_CB = IMGYCBCR(:,:,2);
YCBCR_CR = IMGYCBCR(:,:,3);
figure(5);
subplot(2,2,1);imshow(IMGYCBCR);title('IMGYCBCRͼ');
subplot(2,2,2);imshow(YCBCR_Y);title('Yͨ��ͼ');
subplot(2,2,3);imshow(YCBCR_CB);title('Cbͨ��ͼ');
subplot(2,2,4);imshow(YCBCR_CR);title('Crͨ��ͼ');
%�Ժ�����ͨ��������С����ÿ��һ����ȡһ��
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
%�õ������ݽ���10Ϊ���������Ĳ�����ʾ
y = im2jpeg(YCBCR_Y,10);
cb = im2jpeg(uint8(CB),10);
cr = im2jpeg(uint8(CR),10);%ѹ��

y1 = jpeg2im(y);  
cb1 = jpeg2im(cb);
cr1 = jpeg2im(cr);  %�ָ�
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
subplot(2,2,3);imshow(RGB_HUI);title('��quality=10ʱ');
y = im2jpeg(YCBCR_Y,5);
cb = im2jpeg(uint8(CB),5);
cr = im2jpeg(uint8(CR),5);%ѹ��
y1 = jpeg2im(y);  
cb1 = jpeg2im(cb);
cr1 = jpeg2im(cr);  %�ָ�
cb1 = imresize(cb1,2,'bicubic');
cr1 = imresize(cr1,2,'bicubic');
YCrCb_HUI(:,:,1) = y1;
YCrCb_HUI(:,:,2) = cb1;
YCrCb_HUI(:,:,3) = cr1;
RGB_HUI = ycbcr2rgb(YCrCb_HUI);
subplot(2,2,2);imshow(RGB_HUI);title('��quality=5ʱ');
y = im2jpeg(YCBCR_Y,1);
cb = im2jpeg(uint8(CB),1);
cr = im2jpeg(uint8(CR),1);%ѹ��
y1 = jpeg2im(y);  
cb1 = jpeg2im(cb);
cr1 = jpeg2im(cr);  %�ָ�
cb1 = imresize(cb1,2,'bicubic');
cr1 = imresize(cr1,2,'bicubic');
YCrCb_HUI(:,:,1) = y1;
YCrCb_HUI(:,:,2) = cb1;
YCrCb_HUI(:,:,3) = cr1;
RGB_HUI = ycbcr2rgb(YCrCb_HUI);
subplot(2,2,1);imshow(RGB_HUI);title('��quality=1ʱ');
y = im2jpeg(YCBCR_Y,20);
cb = im2jpeg(uint8(CB),20);
cr = im2jpeg(uint8(CR),20);%ѹ��
y1 = jpeg2im(y);  
cb1 = jpeg2im(cb);
cr1 = jpeg2im(cr);  %�ָ�
cb1 = imresize(cb1,2,'bicubic');
cr1 = imresize(cr1,2,'bicubic');
YCrCb_HUI(:,:,1) = y1;
YCrCb_HUI(:,:,2) = cb1;
YCrCb_HUI(:,:,3) = cr1;
RGB_HUI = ycbcr2rgb(YCrCb_HUI);
subplot(2,2,4);imshow(RGB_HUI);title('��quality=20ʱ');







