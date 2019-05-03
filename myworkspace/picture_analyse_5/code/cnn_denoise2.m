close all, clear all

noisyRGB = imread('D:\bobby\football\C罗民族小学\照片1.png');
noisyRGB = im2double(noisyRGB);

noisyR = noisyRGB(:,:,1);
noisyG = noisyRGB(:,:,2);
noisyB = noisyRGB(:,:,3);

net = denoisingNetwork('dncnn');

denoisedR = denoiseImage(noisyR,net);
denoisedG = denoiseImage(noisyG,net);
denoisedB = denoiseImage(noisyB,net);

denoisedRGB = cat(3,denoisedR,denoisedG,denoisedB);

figure(1),clf,
ax(1) = subplot(1,2,1);imshow(noisyRGB);
ax(2) = subplot(1,2,2);imshow(denoisedRGB);
linkaxes(ax);
