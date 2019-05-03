function ColorSlicing1(I)

%I=imread('..\1crop\00001.jpg');
% I=imread('data\team.jpg');
I = im2double(I);
M = size(I,1);
N = size(I,2);
figure(1),imshow(I);

% choose point of interest
h = impoint;
pos = wait(h);     %Ë«»÷È¡µã
pos = round(pos); 
a = [I(pos(2),pos(1),1) I(pos(2),pos(1),2) I(pos(2),pos(1),3)];
R = 100/255;% radius

D = (I(:,:,1)-a(1)).^2+(I(:,:,2)-a(2)).^2+(I(:,:,3)-a(3)).^2;
mask = D<=R*R;

% choose ROI
figure(2),imshow(mask);
h = imrect;
pos = wait(h);
pos = round(pos);
roi = false(size(mask));
roi(pos(2):pos(2)+pos(4),pos(1):pos(1)+pos(3)) = 1;
mask = mask & roi;

g = rgb2gray(I);
J = I;
J(:,:,1) = g;
J(:,:,2) = g;
J(:,:,3) = g;
idx = find(mask);
J(idx) = I(idx);
J(idx+M*N) = I(idx+M*N);
J(idx+M*N*2) = I(idx+M*N*2);
figure(3),imshow(J,[]);