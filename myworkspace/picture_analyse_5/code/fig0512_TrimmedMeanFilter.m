% fig0512_TrimmedMeanFilter, P351

f = imread('..\data\Fig0507(a)(ckt-board-orig).tif');
f = im2double(f);
g = imread('..\data\Fig0512(b)(ckt-uniform-plus-saltpepr-prob-pt1).tif');
g = im2double(g);

hsize = 5;

% arithmetic mean
h_arithmetic = ones(hsize,hsize)/(hsize*hsize);
f1 = imfilter(g,h_arithmetic);

% geometric mean
fun1 = @(x) power(prod(x(:)),1/(hsize*hsize));
f2 = nlfilter(g,[hsize hsize],fun1);

% median
fun2 = @(x) median(x(:));
f3 = nlfilter(g,[hsize hsize],fun2);

% Trimmed Mean Filter
f4 = TrimmedMeanFilter(g,hsize,6);

figure(1),clf,
ax(1) = subplot(2,3,1);imshow(f),title('Original image');
ax(2) = subplot(2,3,2);imshow(g),title('Noisy image');
ax(3) = subplot(2,3,3);imshow(f1),title('arithmetic mean');
ax(4) = subplot(2,3,4);imshow(f2,[]),title('geometric mean');
ax(5) = subplot(2,3,5);imshow(f3),title('median');
ax(6) = subplot(2,3,6);imshow(f4),title('trimmed mean');
linkaxes(ax);