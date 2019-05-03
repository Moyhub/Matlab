% ex0502_MeanFilters, P345
f = imread('..\data\Fig0507(a)(ckt-board-orig).tif');
f = im2double(f);
g1 = imread('..\data\Fig0507(b)(ckt-board-gauss-var-400).tif');
g1 = im2double(g1);

% arithmetic mean
h_arithmetic = ones(3,3)/9;
f1 = imfilter(g1,h_arithmetic);

% geometric mean
fun1 = @(x) power(prod(x(:)),1/9);
f2 = nlfilter(g1,[3 3],fun1);

figure(1),clf,
ax(1) = subplot(2,2,1);imshow(f);
ax(2) = subplot(2,2,2);imshow(g1);
ax(3) = subplot(2,2,3);imshow(f1);
ax(4) = subplot(2,2,4);imshow(f2);
linkaxes(ax);

