close all
M = 400; N = 400;
[X,Y] = meshgrid(-M/2:M/2-1,-N/2:N/2-1);
phase = 2*pi*0.1*sqrt(X.^2+Y.^2);
f = cos(phase);
figure(1),imshow(f,[])

F1 = fft2(f);
F2 = fftshift(F1);
figure(2),imshow(abs(F2),[]);

f2 = f(M/4:3*M/4-1,:);
figure(3),imshow(f2,[])
F1 = fft2(f2);
F2 = fftshift(F1);
figure(4),imshow(abs(F2),[]);

f3 = zeros(M,N);
f3(M/4:3*M/4-1,:) = f(M/4:3*M/4-1,:);
figure(5),imshow(f3,[])
F1 = fft2(f3);
F2 = fftshift(F1);
figure(6),imshow(abs(F2),[]);
