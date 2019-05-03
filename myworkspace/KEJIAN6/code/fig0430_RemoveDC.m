%fig0430_RemoveDC
I = imread('..\data\Fig0429(a)(blown_ic).tif');
I = im2double(I);
[M,N] = size(I);
F = fftshift(fft2(I));

% check that F(M/2+1,N/2+1) is the center
abs(F(M/2-1:M/2+3,N/2-1:N/2+3))

figure(1),subplot(2,2,1),imshow(I),title('I: Original Image')
subplot(2,2,2),imshow(log(1+abs(F)),[]),title('|F|: Spectrum of I')

F2 = F;
F2(M/2+1,N/2+1) = 0;% remove DC
I2 = real(ifft2(ifftshift(F2)));
mean2(I)
mean2(I2)
subplot(2,2,3),imshow(I2),title('I2: Result of filtering I by removing dc')
I3 = I2+mean2(I);
subplot(2,2,4),imshow(I3),title('I3=I2+mean2(I)')