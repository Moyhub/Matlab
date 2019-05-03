% fig0510_MedianFilter, P350

f = imread('..\data\Fig0507(a)(ckt-board-orig).tif');
f = im2double(f);
g = imread('..\data\Fig0510(a)(ckt-board-saltpep-prob.pt05).tif');
g = im2double(g);

fun = @(x) median(x(:));
f1 = nlfilter(g,[3 3],fun);
f2 = nlfilter(f1,[3 3],fun);
f3 = nlfilter(f2,[3 3],fun);
f4 = nlfilter(f3,[3 3],fun);

figure(1),clf,
ax(1) = subplot(2,3,1);imshow(f);
ax(2) = subplot(2,3,2);imshow(g);
ax(3) = subplot(2,3,3);imshow(f1);
ax(4) = subplot(2,3,4);imshow(f2);
ax(5) = subplot(2,3,5);imshow(f3);
ax(6) = subplot(2,3,6);imshow(f4);
linkaxes(ax);