close all
I1 = imread('F0020.bmp');
I2 = imread('F0133.bmp');
I1 = im2double(I1);
I2 = im2double(I2);

F1 = fftshift(fft2(I1));
F2 = fftshift(fft2(I2));

figure(1),
subplot(2,2,1),imshow(I1);
subplot(2,2,2),imshow(I2);
subplot(2,2,3),imshow(1+log(abs(F1)),[]);
subplot(2,2,4),imshow(1+log(abs(F2)),[]);

figure(2),
I3 = I1(300:400,:);
F2 = fftshift(fft2(I3));
imshow(1+log(abs(F2)),[]);
figure(3),
I3 = zeros(size(I1));
I3(300:400,:) = I1(300:400,:);
F2 = fftshift(fft2(I3));
imshow(1+log(abs(F2)),[]);