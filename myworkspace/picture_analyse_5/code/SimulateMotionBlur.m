% SimulateMotionBlur
I = imread('cameraman.tif');
figure(1),clf,subplot(2,2,1),imshow(I);
H = fspecial('motion',10,0);
MotionBlur = imfilter(I,H,'replicate');
subplot(2,2,2),imshow(MotionBlur);
H = fspecial('motion',20,90);
MotionBlur = imfilter(I,H,'replicate');
subplot(2,2,3),imshow(MotionBlur);
H = fspecial('motion',30,135);
MotionBlur = imfilter(I,H,'replicate');
subplot(2,2,4),imshow(MotionBlur);
