% Zhanwei Xu
% 2017-10-21
close all
img_size = 16;%ͼ��Ĵ�С
mag = 20;%ͼƬ�Ŵ���ٱ���ʾ
img = zeros(img_size, img_size);
img(img_size/4+1:3*img_size/4,3*img_size/8+1:5*img_size/8) = 1;
% img = imread('..\data\1.jpg');
% img = imresize(img,[img_size,img_size]);
% img = rgb2gray(img);%�Ҷ�ͼ
img_show = imresize(img,[img_size*mag,img_size*mag],'nearest');
figure(1),imshow(img_show);%��ʾԭͼ
set(gcf,'name','original image');
img_fft = fftshift(fft2(img));%����Ҷ�任
img_fft_abs = abs(img_fft);%����
img_fft_abs_show = imresize(img_fft_abs,[img_size*mag,img_size*mag],'nearest');
figure(2),imshow(img_fft_abs_show,[])%,colormap(jet);%��ʾ����
set(gcf,'name','amplitude');
figure(3),imshow(log(img_fft_abs_show),[])%,colormap(jet);%���ȶ�����ʾ
set(gcf,'name','log amplitude')
img_fft_angle = angle(img_fft);
img_fft_angle_show = imresize(img_fft_angle,[img_size*mag,img_size*mag],'nearest');
figure(4),imshow(img_fft_angle_show,[])%,colormap(jet)%���ȽǶ���ʾ
set(gcf,'name','angle')
b = 1;
while(b)
    figure(3),[x,y] = ginput(1);%ѡ��
    if isempty(x)
        break
    end
    hold on,plot(x,y,['*','r']),hold off;
    Amp = img_fft_abs(floor(x/mag)+1,floor(y/mag)+1);
    Angle = img_fft_angle(floor(x/mag)+1,floor(y/mag)+1);
    x = double(mod(floor(x/mag+img_size/2),img_size));
    y = double(mod(floor(y/mag+img_size/2),img_size));
    [x_row,y_row] = meshgrid(0:1:img_size-1);
    real = cos(2*pi*x*x_row/img_size+2*pi*y*y_row/img_size);
    imag = sin(2*pi*x*x_row/img_size+2*pi*y*y_row/img_size);
    real_show = imresize(real,[img_size*mag,img_size*mag],'nearest');
    imag_show = imresize(imag,[img_size*mag,img_size*mag],'nearest');

    %��ʾ��ѡ������Ƶ�ε�ʵ��ͼ���鲿ͼ
    figure(5)
    subplot(1,2,1),imshow(real_show,[])%,colormap(jet)
    title('real part')
    subplot(1,2,2),imshow(imag_show,[])%,colormap(jet)
    title('imaginary part')
    figure(4),set(gcf,'name',['phase is ' num2str(Angle)]);
    figure(3),set(gcf,'name',['amplitutude is ' num2str(Amp)]);
%     suptitle(['the amplitutude is ',num2str(Amp),' and the angle is ',num2str(Angle)])
%     b = input('press 0 to stop and 1 to continue')
end