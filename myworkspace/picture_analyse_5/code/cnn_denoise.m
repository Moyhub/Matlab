% https://ww2.mathworks.cn/help/images/remove-noise-from-color-image-using-pretrained-neural-network.html
%
% Jianjiang Feng
% 2018.07.26

close all, clear all

pristineRGB = imread('lighthouse.png');
pristineRGB = im2double(pristineRGB);

% Simulate noise
noisyRGB = imnoise(pristineRGB,'gaussian',0,0.01);

noisyR = noisyRGB(:,:,1);
noisyG = noisyRGB(:,:,2);
noisyB = noisyRGB(:,:,3);

% Mean
tic;
h_mean = ones(3,3)/9;
denoisedR_mean = imfilter(noisyR,h_mean);
denoisedG_mean = imfilter(noisyG,h_mean);
denoisedB_mean = imfilter(noisyB,h_mean);
denoisedRGB_mean = cat(3,denoisedR_mean,denoisedG_mean,denoisedB_mean);
fprintf('Time of mean: %.3f\n', toc);

% CNN
tic;
net = denoisingNetwork('dncnn');
denoisedR_cnn = denoiseImage(noisyR,net);
denoisedG_cnn = denoiseImage(noisyG,net);
denoisedB_cnn = denoiseImage(noisyB,net);
denoisedRGB_cnn = cat(3,denoisedR_cnn,denoisedG_cnn,denoisedB_cnn);
fprintf('Time of CNN: %.3f\n', toc);

figure(1),clf,
ax(1) = subplot(2,2,1);imshow(pristineRGB);title('Original Image')
ax(2) = subplot(2,2,2);imshow(noisyRGB);title('Noisy Image')
ax(3) = subplot(2,2,3);imshow(denoisedRGB_mean);title('Denoised Image by mean')
ax(4) = subplot(2,2,4);imshow(denoisedRGB_cnn);title('Denoised Image by CNN')
linkaxes(ax);

noisyPSNR = psnr(noisyRGB,pristineRGB);
fprintf('\n The PSNR value of the noisy image is %0.4f.',noisyPSNR);
denoisedPSNR_mean = psnr(denoisedRGB_mean,pristineRGB);
fprintf('\n The PSNR value of the denoised image by mean is %0.4f.',denoisedPSNR_mean);
denoisedPSNR_cnn = psnr(denoisedRGB_cnn,pristineRGB);
fprintf('\n The PSNR value of the denoised image by CNN is %0.4f.',denoisedPSNR_cnn);

noisySSIM = ssim(noisyRGB,pristineRGB);
fprintf('\n The SSIM value of the noisy image is %0.4f.',noisySSIM);
denoisedSSIM_mean = ssim(denoisedRGB_mean,pristineRGB);
fprintf('\n The SSIM value of the denoised image by meanis %0.4f.',denoisedSSIM_mean);
denoisedSSIM_cnn = ssim(denoisedRGB_cnn,pristineRGB);
fprintf('\n The SSIM value of the denoised image by CNN is %0.4f.\n',denoisedSSIM_cnn);