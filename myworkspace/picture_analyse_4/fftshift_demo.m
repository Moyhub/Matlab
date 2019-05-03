%fftshift_demo
close all
f = zeros(400,400);
[M,N] = size(f);
f(M/2-10:M/2+10,N/2-20:N/2+20) = 1;

F1 = fft2(f);
figure(1),imshow(f),title('Original image')
figure(2),imshow(log(1+abs(F1)),[]),title('DFT')

[X,Y] = meshgrid(0:M-1,0:N-1);
F2 = fft2(f .* ((-ones(M,N)).^(X+Y)));
figure(3),imshow(log(1+abs(F2)),[]),title('DFT shifted by (-1)^{(x+y)}')

F3 = fftshift(F1);
figure(4),imshow(log(1+abs(F3)),[]),title('DFT shifted by fftshift function')
