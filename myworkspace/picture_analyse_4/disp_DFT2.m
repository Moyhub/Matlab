clc;
wavecreator;

serial=[11 12 13 14 21 22 23 31 32 33];
for i=1:length(serial)
    figure;
    f=eval(['f',num2str(serial(i))]);
    
    subplot(1,3,1);
    imshow(f);
    title('origin');
    
    subplot(1,3,2);
    img_out=DFT2(f);
    imshow(img_out(:,:,1));
    title('abs');
    
    subplot(1,3,3);
    imshow(img_out(:,:,2));
    title('angle');
    saveas(gcf,num2str(i),'jpg');
end