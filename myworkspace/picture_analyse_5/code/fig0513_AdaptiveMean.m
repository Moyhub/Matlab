% fig0513_AdaptiveMean, P353
clear all
f = imread('..\data\Fig0507(a)(ckt-board-orig).tif');
f = im2double(f);
var_noise_real = 1000/(255*255);
var_noise = var_noise_real;
% var_noise = var_noise_real-0.01;
% var_noise = var_noise_real+0.02;
noise = randn(size(f,1),size(f,2))*sqrt(var_noise_real);
g = f + noise;

hsize = 7;

% arithmetic mean
h_arithmetic = ones(hsize,hsize)/(hsize*hsize);
f1 = imfilter(g,h_arithmetic);

% geometric mean
fun1 = @(x) power(prod(x(:)),1/(hsize*hsize));
f2 = nlfilter(g,[hsize hsize],fun1);

% adaptive mean
% Compute local mean and local variance
fun1 = @(x) mean(x(:));
mean_local = nlfilter(g,[hsize hsize],fun1);
fun2 = @(x) var(x(:));
var_local = nlfilter(g,[hsize hsize],fun2);
mask = var_local<var_noise;
w = var_noise./(var_local+eps);
w(mask) = 1;
f3 = (1-w).*g + w.*mean_local;

figure(1),clf,
ax(1) = subplot(3,3,1);imshow(f),title('Original image');
ax(2) = subplot(3,3,2);imshow(g),title('Noisy image');
ax(3) = subplot(3,3,3);imshow(f1),title('arithmetic mean');
ax(4) = subplot(3,3,4);imshow(f2,[]),title('geometric mean');
ax(5) = subplot(3,3,5);imshow(f3),title('adaptive mean');
ax(6) = subplot(3,3,6);imshow(mean_local),title('local mean');
ax(7) = subplot(3,3,7);imshow(var_local,[]),title('local variance');
ax(8) = subplot(3,3,8);imshow(mask,[]),title('mask');
ax(9) = subplot(3,3,9);imshow(w,[]),title('weight');
linkaxes(ax);