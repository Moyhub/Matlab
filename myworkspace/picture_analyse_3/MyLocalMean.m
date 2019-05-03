function Mean_Local = MyLocalMean(I,filter)
%I:输入图像
%边界填充
f_m=filter(1);f_n = filter(2);
[m,n] = size(I);
I_enlarge = zeros(m+f_m-1,n+f_n-1);
I_enlarge(floor((f_m-1)/2)+1:floor((f_m-1)/2)+m,floor((f_n-1)/2)+1:((f_n-1)/2)+n)=I;
I = I_enlarge;
[m,n] = size(I);
I = double(I);
Integral_image = zeros(m,n);%积分图像
%计算积分图像
for i = 1:m
    for j = 1:n
        if i==1 && j==1
            Integral_image(i,j) = I(i,j);
        elseif i==1 && j~=1
            Integral_image(i,j) = Integral_image(i,j-1)+I(i,j);
        elseif i~=1 && j==1
            Integral_image(i,j) = Integral_image(i-1,j)+I(i,j);
        else
            Integral_image(i,j) = I(i,j)+Integral_image(i-1,j)+Integral_image(i,j-1)-Integral_image(i-1,j-1);
        end
    end
end

Integral_image_enlarge = zeros(1+m,1+n);
Integral_image_enlarge(2:end,2:end)=Integral_image;

for i = 1:(m+1-f_m)
    for j =1:(n+1-f_n)
        Mean_Local(i,j) = (Integral_image_enlarge(i+f_m,j+f_n)+ Integral_image_enlarge(i,j+f_n) + Integral_image_enlarge(i+f_m,j) - Integral_image_enlarge(i,j))/(f_m*f_n);
    end
end




