
imgPath = 'C:\Users\MacBook Air\Documents\HW\';
imgDir = dir([imgPath ,'*.jpg']);
imgDIR = dir([imgPath ,'*.txt']);

for i=1:length(imgDir)
    img =imread([imgPath,imgDir(i).name]);
    data=textread([imgPath,imgDIR(i).name]);
    imshow(img);hold on;
    for j=1:1:68
      plot(data(j,1),data(j,2),'r*','markersize',8);
    end
    hold off;
end


        



 

