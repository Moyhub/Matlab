%ex0423_notchNoPadding
f = imread('..\data\Fig0464(a)(car_75DPI_Moire).tif');
f = im2double(f);
[M,N] = size(f);
% P = max(2*[M N]);% Padding size. 
F = fftshift(fft2(f));

close all
figure(1),imshow(f,[]);
figure(2),imshow(log(1+abs(F)),[]);

% Find the locations of maxima
if 0
    impixelinfo;
    return
end

% Creat 4 pairs of notch reject filters
% p = [327 163; 327 80; 333 324; 333 406];% locations of maxima, found by impixelinfo
p = [112 41; 112 82; 114 162; 115 203];
H = ones(size(f));
[DX, DY] = meshgrid(1:N,1:M);
D0 = 10;
n = 2;
for k = 1:4
    Dk1 = sqrt((DX-p(k,1)).^2+(DY-p(k,2)).^2);
    Dk2 = sqrt((DX-N-2+p(k,1)).^2+(DY-M-2+p(k,2)).^2);
    H1 = 1./(1+(D0./Dk1).^(2*n));
    H2 = 1./(1+(D0./Dk2).^(2*n));
    H = H.*H1.*H2;
end
figure(3),imshow(H,[]);

% Filtering
G = H.*F;
g = real(ifft2(ifftshift(G)));

figure(4),imshow(log(1+abs(G)),[]);
figure(5),imshow(g,[]);