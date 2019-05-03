close all, clear all
% Construct a rectangular box
f = zeros(30,30);
f(5:24,13:17) = 1;
figure(1),imshow(f,'InitialMagnification','fit')
figure(2),surf(f);

% Compute and visualize the 30-by-30 DFT of f
% F = fft2(f);

% F2 = log(abs(F));
% figure(2),imshow(F2,[-1 5],'InitialMagnification','fit');
% colormap(jet); colorbar

% To obtain a finer sampling of the Fourier transform, add zero padding
% to f when computing its DFT.
F = fft2(f,256,256);
step = 4;

% figure(3),imshow(log(abs(F)),[-1 5]); colormap(jet); colorbar
% figure(4),surf(real(F(1:step:end,1:step:end)));

% Swap the quadrants of F so that the zero-frequency coefficient is in the center.
F2 = fftshift(F);
figure(5),imshow(log(abs(F2)),[-1 5]); %colormap(jet); colorbar
figure(6),surf(log(abs(F2(1:step:end,1:step:end))));

figure(7),imshow(angle(F2),[]); 
figure(8),surf(angle(F2(1:step:end,1:step:end)));