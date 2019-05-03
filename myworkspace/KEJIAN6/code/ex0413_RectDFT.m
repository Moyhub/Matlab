%ex0413_RectDFT
f = imread('..\data\Fig0424(a)(rectangle).tif');
f = imresize(f,0.5);
F = fftshift(fft2(f));
figure(1),clf,subplot(2,3,1),imshow(f,[])
subplot(2,3,2),imshow(log(1+abs(F)),[])
subplot(2,3,3),imshow(angle(F),[])

f2 = imread('..\data\Fig0425(a)(translated_rectangle).tif');
F2 = fftshift(fft2(f2));
figure(1),subplot(2,3,4),imshow(f2,[])
subplot(2,3,5),imshow(log(1+abs(F2)),[])
subplot(2,3,6),imshow(angle(F2),[])

f3 = imrotate(f,30,'bilinear','crop');
F3 = fftshift(fft2(f3));
figure(2),clf,subplot(2,3,1),imshow(f,[])
subplot(2,3,2),imshow(log(1+abs(F)),[])
subplot(2,3,3),imshow(angle(F),[])
figure(2),subplot(2,3,4),imshow(f3,[])
subplot(2,3,5),imshow(log(1+abs(F3)),[])
subplot(2,3,6),imshow(angle(F3),[])