f1 = imread('..\data\Fig0427(a)(woman).tif');
f2 = imread('..\data\Fig0424(a)(rectangle).tif');
f2 = imresize(f2,0.5);

figure(1),imshow(f1,[]);
figure(2),imshow(f2,[]);

F1 = fft2(f1);
phase1 = angle(F1);
F1_phaseOnly = cos(phase1) + 1i*sin(phase1);
f1_phaseOnly = real(ifft2(F1_phaseOnly));
f1_magnitudeOnly = real(ifft2(abs(F1)));

figure(3),imshow(log(1+abs(fftshift(F1))),[]);
figure(4),imshow(phase1,[]);
figure(5),imshow(f1_phaseOnly,[]);
figure(6),imshow(f1_magnitudeOnly,[]);

F2 = fft2(f2);
phase2 = angle(F2);
F2_phaseOnly = cos(phase2) + 1i*sin(phase2);
f1_mixed = real(ifft2(abs(F2).*F1_phaseOnly));
f2_mixed = real(ifft2(abs(F1).*F2_phaseOnly));
figure(7),imshow(f1_mixed,[]);
figure(8),imshow(f2_mixed,[]);
