% Gabor filter
I = imread('..\data\F0020.bmp');
I = im2double(I);
wavelength = 10;
orientation = 90;
[mag,phase] = imgaborfilt(I,wavelength,orientation);

figure(2),clf
subplot(3,3,1),imshow(I),title('Original image');
subplot(3,3,2),imshow(mag,[]),title('Gabor magnitude');
subplot(3,3,3),imshow(phase,[]),title('Gabor phase');
subplot(3,3,4),imshow(mag.*cos(phase),[]),title('Gabor real');
subplot(3,3,5),imshow(mag.*sin(phase),[]),title('Gabor imaginary');

F = fftshift(fft2(I));
subplot(3,3,6),imshow(log(1+abs(F)),[]),title('DFT of original image');
J = imadjust(mag.*cos(phase),[],[]);
F = fftshift(fft2(J));
subplot(3,3,7),imshow(log(1+abs(F)),[]),title('DFT of Gabor real');