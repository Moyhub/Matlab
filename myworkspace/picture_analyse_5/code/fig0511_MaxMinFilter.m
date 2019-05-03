% fig0511_MaxMinFilter, P350

g1 = imread('..\data\Fig0508(a)(circuit-board-pepper-prob-pt1).tif');
g1 = im2double(g1);
g2 = imread('..\data\Fig0508(b)(circuit-board-salt-prob-pt1).tif');
g2 = im2double(g2);

fun1 = @(x) max(x(:));
fun2 = @(x) min(x(:));
f1 = nlfilter(g1,[3 3],fun1);
f2 = nlfilter(g2,[3 3],fun2);

figure(1),clf,
ax(1) = subplot(2,2,1);imshow(g1);
ax(2) = subplot(2,2,2);imshow(g2);
ax(3) = subplot(2,2,3);imshow(f1);
ax(4) = subplot(2,2,4);imshow(f2);
linkaxes(ax);