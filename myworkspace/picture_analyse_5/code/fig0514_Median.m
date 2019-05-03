% fig0514_Median, P356
clear all
f = imread('..\data\Fig0507(a)(ckt-board-orig).tif');
g = imread('..\data\Fig0514(a)(ckt_saltpep_prob_pt25).tif');

fun1 = @(x) median(x(:));
f1 = nlfilter(g,[3 3],fun1);
f2 = nlfilter(g,[5 5],fun1);
f3 = nlfilter(g,[7 7],fun1);
f4 = nlfilter(g,[9 9],fun1);

figure(1),clf,
ax(1) = subplot(2,3,1);imshow(f),title('Original image');
ax(2) = subplot(2,3,2);imshow(g),title('Noisy image');
ax(3) = subplot(2,3,3);imshow(f1),title('median 3x3');
ax(4) = subplot(2,3,4);imshow(f2),title('median 5x5');
ax(5) = subplot(2,3,5);imshow(f3),title('median 7x7');
ax(6) = subplot(2,3,6);imshow(f4),title('median 9x9');
linkaxes(ax);