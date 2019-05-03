function ColorSlicing(img)

I=imread('1crop\00001.jpg');
% I=imread('data\team.jpg');
I = im2double(I);
M = size(I,1);
N = size(I,2);
figure(1),imshow(I);

% choose point of interest
% h = impoint;
% pos = wait(h);     %Ë«»÷È¡µã
% pos = round(pos); 
a = [I(375,47,1) I(375,48,2) I(375,48,3)];
R = 100/255;% radius

D = (I(:,:,1)-a(1)).^2+(I(:,:,2)-a(2)).^2+(I(:,:,3)-a(3)).^2;
mask = D<=R*R;

% choose ROI
figure(2),imshow(mask);
% h = imrect;
% pos = wait(h);
% pos = round(pos);
roi = false(size(mask));
roi(1:140,1:size(I,2)) = 1;
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

    for i = 1:size(J,1)
        for j = 1:size(J,2)
            if(J(i,j,2)==J(i,j,1) && J(i,j,2)==J(i,j,3) && J(i,j,1) == J(i,j,3))
                J(i,j,1)=1;
                J(i,j,2)=1;
                J(i,j,3)=1;
            end
        end
    end

figure(3),imshow(J);