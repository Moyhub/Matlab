close all
%使用相位和幅度对图像进行重建的效果比较
f1 = rgb2gray(imread('bobby.bmp'));
F1 = fftshift(fft2(f1));
P1 = angle(F1);
M1 = abs(F1);
figure(1), subplot(1,3,1), imshow(f1), title('image')
subplot(1,3,2), imshow(log(M1+1),[]), title('magnitude')
subplot(1,3,3), imshow(P1,[]), title('phase')

% rectangle
[h, w] = size(f1);
f2 = zeros(h, w);
side_len = 0.1;
r1 = ceil((0.5-side_len/2)*h);
r2 = ceil((0.5+side_len/2)*h);
c1 = ceil((0.5-side_len/2)*w);
c2 = ceil((0.5+side_len/2)*w);
f2(r1:r2,c1:c2) = 1;
F2 = fftshift(fft2(f2));
P2 = angle(F2);
M2 = abs(F2);
figure(2), subplot(1,3,1), imshow(f2), title('image')
subplot(1,3,2), imshow(log(M2+1),[]), title('magnitude')
subplot(1,3,3), imshow(P2,[]), title('phase')

% use magnitude of face to reconstruct
recon1_magnitude = (ifft2(ifftshift(M1)));
figure(3), subplot(1,3,1), imshow(real(recon1_magnitude), []), title('magnitude of face')

% use phase of face to reconstruct
F1_phase = cos(P1) + 1i*sin(P1);
recon1_phase = (ifft2(ifftshift(F1_phase)));
figure(3), subplot(1,3,2), imshow(real(recon1_phase), []), title('phase of face')

% use phase of face and magnitude of rectangle to reconstruct
F1_phase1_mag2 = F1_phase .* M2;
recon1_phase1_mag2 = (ifft2(ifftshift(F1_phase1_mag2)));
figure(3), subplot(1,3,3), imshow(real(recon1_phase1_mag2), []), title('phase of face + magnitude of rectangle')