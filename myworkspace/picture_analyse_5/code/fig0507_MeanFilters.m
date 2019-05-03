% fig0507_MeanFilters, P346
f = imread('..\data\Fig0507(a)(ckt-board-orig).tif');
f = im2double(f);
g = imread('..\data\Fig0507(b)(ckt-board-gauss-var-400).tif');
g = im2double(g);

% arithmetic mean
h_arithmetic = ones(3,3)/9;
f1 = imfilter(g,h_arithmetic);

% geometric mean
fun1 = @(x) power(prod(x(:)),1/9);
f2 = nlfilter(g,[3 3],fun1);

figure(1),clf,
ax(1) = subplot(2,2,1);imshow(f);
ax(2) = subplot(2,2,2);imshow(g);
ax(3) = subplot(2,2,3);imshow(f1);
ax(4) = subplot(2,2,4);imshow(f2);
linkaxes(ax);