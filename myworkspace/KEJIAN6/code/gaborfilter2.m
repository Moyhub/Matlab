% Gabor filter
I = imread('..\data\F0020.bmp');

% Create array of Gabor filters. This filter bank contains two orientations and two wavelengths.
orientation_num = 8;
orientations = [0:orientation_num-1]*180/orientation_num;
wavelengths = 10;
gaborArray = gabor(wavelengths,orientations);
% Apply filters to input image.
[mag,phase] = imgaborfilt(I,gaborArray);

close all,
figure(5), imshow(I), set(5, 'name', 'Original image');
ax = gca;
figure(1), set(1, 'name', 'Even Gabor');
figure(2), set(2, 'name', 'Odd Gabor');
figure(3), set(3, 'name', 'Magnitude');
figure(4), set(4, 'name', 'Phase');
figure(5), set(5, 'name', 'Filter');
for p = 1:orientation_num
    figure(1),ax(end+1) = subplot(2,4,p);
    imshow(mag(:,:,p).*cos(phase(:,:,p)),[]);
    figure(2),ax(end+1) = subplot(2,4,p);
    imshow(mag(:,:,p).*sin(phase(:,:,p)),[]);
    figure(3),ax(end+1) = subplot(2,4,p);
    imshow(mag(:,:,p),[]);
    figure(4),ax(end+1) = subplot(2,4,p);
    imshow(phase(:,:,p),[]);
    for k = 1:4
        figure(k),subplot(2,4,p)
        theta = gaborArray(p).Orientation;
        lambda = gaborArray(p).Wavelength;
        title(sprintf('Orientation=%.1f, Wavelength=%d',theta,lambda));
    end
    figure(5),subplot(4,4,p),imshow(real(gaborArray(p).SpatialKernel),[]);
    subplot(4,4,8+p),imshow(imag(gaborArray(p).SpatialKernel),[]);
end
linkaxes(ax);
