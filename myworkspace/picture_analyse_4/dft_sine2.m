close all, clear all£»

% Construct 2D sine wave
[X, Y] = meshgrid(1:256);
[M,N] = size(X);
f1 = cos(2*pi*0.03*(cos(pi/3)*X+sin(pi/3)*Y));
figure(1)
subplot(2,2,1),imshow(f1,[])

sigma = 40;
wnd = exp(-((X-M/2).^2+(Y-N/2).^2)/(2*sigma*sigma));
f2 = f1.*wnd;
subplot(2,2,2),imshow(f2,[])

% Compute and visualize the 30-by-30 DFT of f
F = fft2(f1);
F2 = fftshift(F);
subplot(2,2,3),imshow(log(abs(F2)),[]);

F = fft2(f2);
F2 = fftshift(F);
subplot(2,2,4),imshow(log(abs(F2)),[]);
