D0=5;
P=1000;
ns = [1 2 5 20];
close all
for k = 1:length(ns)
    H = blpf(D0,ns(k),P);
    g = real(fftshift(ifft2(ifftshift(H))));
    figure(1),subplot(2,2,k),imshow(g,[]),title(['\it{n}=' num2str(ns(k))]);
    figure(2),subplot(2,2,k),mesh(g(1:25:end,1:25:end)),title(['\it{n}=' num2str(ns(k))]);
    figure(3),subplot(2,2,k),plot(1:P,g(P/2+1,:)),title(['\it{n}=' num2str(ns(k))]);
end