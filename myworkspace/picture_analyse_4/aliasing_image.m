close all
I = imread('Fig0417(a)(barbara).tif');
a = 0.5;
I2 = imresize(I,a,'nearest');
I3 = imresize(I2,1/a,'nearest');
figure(1)
subplot(1,2,1),imshow(I);
subplot(1,2,2),imshow(I3);
J = imfilter(I,ones(3,3)/9);
J2 = imresize(J,a,'nearest');
J3 = imresize(J2,1/a,'nearest');
figure(2)
subplot(1,2,1),imshow(I);
subplot(1,2,2),imshow(J3);

% I = imread('..\data\Fig0418(a)(ray_traced_bottle_original).tif');
% a = 0.25;
% I2 = imresize(I,a,'bilinear');
% I3 = imresize(I2,1/a,'nearest');
% figure(2)
% subplot(1,2,1),imshow(I);
% subplot(1,2,2),imshow(I3);

% I = imread('..\data\F0020.bmp');
% a = 0.5;
% I2 = imresize(I,0.5,'bilinear');
% I3 = imresize(I2,a,'bilinear');
% I4 = imresize(I3,1/a,'nearest');
% figure(1)
% subplot(1,2,1),imshow(I2);
% subplot(1,2,2),imshow(I4);
