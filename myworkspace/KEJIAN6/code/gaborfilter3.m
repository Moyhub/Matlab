% Gabor filter
I = imread('D:\data\fvc2002\db1_a\image\10_1.bmp');
I = im2double(I);
[M, N] = size(I);

% Create array of Gabor filters. This filter bank contains two orientations and two wavelengths.
orientation_num = 16;
orientations = [0:orientation_num-1]*180/orientation_num;
wavelengths = 10;
gaborArray = gabor(wavelengths,orientations);
% Apply filters to input image.
[mag,phase] = imgaborfilt(I,gaborArray);

% Select the orientation with largest magnitude for each pixel
[~,filter_idx] = max(mag,[],3);
idx1 = [1:M*N]';
idx2 = idx1+(filter_idx(:)-1)*M*N;
J = I;
J(idx1) = mag(idx2).*cos(phase(idx2));

close all
figure(1),imshow(I);
figure(2),imshow(J,[]);
