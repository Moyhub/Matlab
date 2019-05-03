D0=5;
P=1000;
H = ilpf(D0,P);
g = real(fftshift(ifft2(ifftshift(H))));
close all
figure(1),imshow(g,[]);
figure(2),mesh(g(1:25:end,1:25:end))
figure(3),plot(1:P,g(P/2+1,:));

g = real(fftshift(ifft2(ifftshift(1-H))));
figure(1),imshow(log(1+g),[]);
figure(2),mesh(g(1:25:end,1:25:end))
figure(3),plot(1:P,g(P/2+1,:));
