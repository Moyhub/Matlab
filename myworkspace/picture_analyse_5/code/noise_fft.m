N = 32;
f = randn(N,N);
F = fftshift(fft2(f));
figure(1),subplot(1,2,1),imshow(f,[]),title('Gaussian noise');
subplot(1,2,2),imshow((abs(F)),[]),title('Magnitude spectrum');