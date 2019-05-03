% fig0514_AdaptiveMedian, P356
clear all
f = imread('..\data\Fig0507(a)(ckt-board-orig).tif');
% g = imread('..\data\Fig0514(a)(ckt_saltpep_prob_pt25).tif'); %大小和原图不一样
g = imnoise(f,'salt & pepper',0.25);

local_median = cell(1,3);
local_max = cell(1,3);
local_min = cell(1,3);

fun_median = @(x) median(x(:));
fun_max = @(x) max(x(:));
fun_min = @(x) min(x(:));

sizes = [3 5 7];
for k = 1:3
    local_median{k} = nlfilter(g,[sizes(k) sizes(k)],fun_median);
    local_max{k} = nlfilter(g,[sizes(k) sizes(k)],fun_max);
    local_min{k} = nlfilter(g,[sizes(k) sizes(k)],fun_min);
end

f_adaptive = local_median{3};
flag = 3*ones(size(g));
for m = 1:size(g,1)
    for n = 1:size(g,2)
        for k = 1:3
            if local_median{k}(m,n)>local_min{k}(m,n) && local_median{k}(m,n)<local_max{k}(m,n)
                if g(m,n)>local_min{k}(m,n) && g(m,n)<local_max{k}(m,n)
                    f_adaptive(m,n) = g(m,n);
                    flag(m,n) = 0;
                else
                    f_adaptive(m,n) = local_median{k}(m,n);
                    flag(m,n) = k;
                end
                break
            end
        end
    end
end

figure(1),clf,
ax(1) = subplot(2,3,1);imshow(f),title('Original image');
ax(2) = subplot(2,3,2);imshow(g),title('Noisy image');
ax(3) = subplot(2,3,3);imshow(local_median{3}),title('median 7x7');
ax(4) = subplot(2,3,4);imshow(f_adaptive),title('adaptive median 7x7');
ax(5) = subplot(2,3,5);imshow(flag,[]),title('flag');
linkaxes(ax);