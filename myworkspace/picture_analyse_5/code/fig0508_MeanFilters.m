% fig0508_MeanFilters, P347

% contraharmonic mean
g1 = imread('..\data\Fig0508(a)(circuit-board-pepper-prob-pt1).tif');
g1 = im2double(g1);
g2 = imread('..\data\Fig0508(b)(circuit-board-salt-prob-pt1).tif');
g2 = im2double(g2);

Q1 = 1.5;
fun1 = @(x) sum(x(:).^(Q1+1))/(eps+sum(x(:).^Q1));
Q2 = -1.5;
fun2 = @(x) sum(x(:).^(Q2+1))/(eps+sum(x(:).^Q2));

f1 = nlfilter(g1,[3 3],fun1);
f2 = nlfilter(g1,[3 3],fun2);

f3 = nlfilter(g2,[3 3],fun2);
f4 = nlfilter(g2,[3 3],fun1);

figure(1),clf,
ax(1) = subplot(2,3,1);imshow(g1);
ax(2) = subplot(2,3,4);imshow(g2);
ax(3) = subplot(2,3,2);imshow(f1);
ax(4) = subplot(2,3,3);imshow(f2);
ax(5) = subplot(2,3,5);imshow(f3);
ax(6) = subplot(2,3,6);imshow(f4);
linkaxes(ax);