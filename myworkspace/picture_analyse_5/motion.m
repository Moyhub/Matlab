%�˶�ģ��
%ǰ�ڿ�ͼ����
 [img,map] = imread('car.bmp');
 img1 = ind2rgb(img,map);
% imshow(img1);
%�˶�ģ��
img2 = im2double(imread('car2.bmp'));
img3 = im2double(imread('car3.bmp'));
PSF = fspecial('motion',20,0);
first = imfilter(img3,PSF,'conv','circular');
first = imlincomb(1,img2,1,first); 
figure(1);subplot(2,2,1);
imshow(first);title('ǰ��ģ��ͼ');
img4 = im2double( imread('car4.bmp'));
img5 = im2double( imread('car5.bmp'));
PSF1 = fspecial('motion',25,0);
second = imfilter(img4,PSF1,'conv','circular');
second = imlincomb(1,second,1,img5);
subplot(2,2,2);
imshow(second);title('���˶�ģ��');
%�����˹����
a = 500;  %��˹���������Ҫѭ��ע��
%a =1000;
%a =1200;
J = imnoise(first,'gaussian',0,a/255^2);
subplot(2,2,3);
imshow(J);title('ǰ��ģ��ͼ�����˹����');
J1 = imnoise(second,'gaussian',0,a/255^2);
subplot(2,2,4);
imshow(J1);title('��ģ��ͼ�����˹����');
[m,n,p] = size(J);
P = max([m n p]);
JDFT = fftshift(fft2(J,P,P));
PSF_1 = fftshift(fft2(PSF,P,P));
if(abs(PSF_1)>1)
    R = 1./PSF_1;
else
    R = 1/1;
end
J1_result = JDFT.*R;
J1_result = real(ifft2(ifftshift(J1_result)));
J1_result = J1_result(1:m,1:n);
figure(2);subplot(2,3,1);
imshow(J1_result);title('���˲���ǰ��ģ��ͼ');

J1DFT = fftshift(fft2(J1,P,P));
PSF_2 = fftshift(fft2(PSF1,P,P));
if(abs(PSF_2)>1)
    R1 = 1./PSF_2;
else
    R1 = 1/1;
end
J2_result = J1DFT.*R1;
J2_result = real(ifft2(ifftshift(J2_result)));
J2_result = J2_result(1:m,1:n);
subplot(2,3,2);
imshow(J2_result);title('���˲��ĺ�ģ��ͼ');
%ά���˲�
%������Ϊû��δ�˻�ͼ
k=0.2;
J1W_result = deconvwnr(J,PSF,k);
subplot(2,3,3);
imshow(J1W_result);title('δ֪ԭͼά��ǰ��ģ��ͼ�ָ�')
J2W_result = deconvwnr(J1,PSF1,k);
subplot(2,3,4);
imshow(J2W_result);title('δ֪ԭͼά�ɺ�ģ��ͼ�ָ�')
%ʹ��δ�˻�ͼ
K = (a/255^2) / var(img1(:)) ;
J1W_result_1 = deconvwnr(J,PSF,K);
subplot(2,3,5);
imshow(J1W_result_1);title('��֪ԭͼά�ɵ�ǰ��ģ��ͼ')
J1W_result_2 = deconvwnr(J1,PSF1,K);
subplot(2,3,6);
imshow(J1W_result_2);title('��֪ԭͼά�ɵĺ�ģ��ͼ')

















