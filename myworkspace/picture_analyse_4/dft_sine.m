close all, clear all

% Construct 2D sine wave
[X, Y] = meshgrid(1:256);
f1 = cos(2*pi*0.05*X);
figure(1),
subplot(2,3,1),imshow(f1,[])

% Compute and visualize the 30-by-30 DFT of f
F = fft2(f1);
F2 = fftshift(F);
subplot(2,3,4),imshow(abs(F2),[]);

% Construct 2D sine wave
f2 = cos(2*pi*0.1*Y);
subplot(2,3,2),imshow(f2,[])

% Compute and visualize the 30-by-30 DFT of f
F = fft2(f2);
F2 = fftshift(F);
subplot(2,3,5),imshow(abs(F2),[]);

% Construct 2D sine wave
f3 = cos(2*pi*0.03*(cos(pi/3)*X+sin(pi/3)*Y));
subplot(2,3,3),imshow(f3,[])

% Compute and visualize the 30-by-30 DFT of f
F = fft2(f3);
F2 = fftshift(F);
subplot(2,3,6),imshow(abs(F2),[]);
