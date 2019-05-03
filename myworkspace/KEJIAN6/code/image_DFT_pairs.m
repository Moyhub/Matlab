f = im2double(imread('..\data\F0020.bmp'));
[] = size(f);
meshgrid();
g = ;
F = fftshift(fft2(f));
figure(2),imshow(log(abs(F)+1),[]);