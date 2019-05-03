% Wiener filtering
close all
I = im2double(imread('cameraman.tif'));
figure(1),
subplot(2,3,1), imshow(I);
title('Original Image (courtesy of MIT)');

LEN = 21;
THETA = 11;
PSF = fspecial('motion', LEN, THETA);
blurred = imfilter(I, PSF, 'conv', 'circular');
subplot(2,3,2), imshow(blurred)
title('Simulate Blur');

noise_mean = 0;
noise_var = 0.001;
blurred_noisy = imnoise(blurred, 'gaussian', noise_mean, noise_var);
subplot(2,3,3), imshow(blurred_noisy)
title('Simulate Blur and Noise')

estimated_nsr = 0;
wnr2 = deconvwnr(blurred_noisy, PSF, estimated_nsr);
subplot(2,3,4), imshow(wnr2)
title('Restoration of Blurred, Noisy Image Using NSR = 0')

estimated_nsr = noise_var / var(I(:));
wnr3 = deconvwnr(blurred_noisy, PSF, estimated_nsr);
subplot(2,3,5), imshow(wnr3)
title('Restoration of Blurred, Noisy Image Using Estimated NSR');