function output = Normalization (img,flag)
    average = mean2(img) ;
    variance = std2(img).^2;
    [m,n] = size(img);
    %需要调参
    if(flag ==1)
        M0 = 0.9;
        VAR0 = 1.0;
    elseif(flag==2)
        M0 =1.4;
        VAR0 = 0.9;
    else
        M0 = 1.9;
        VAR0 = 10;
    end
    for i = 1:m 
        for j = 1:n
            if(img(i,j) > average)
                img(i,j) = M0 + sqrt(  (VAR0*(img(i,j)-average).^2)/variance  );
            else
                img(i,j) = M0 - sqrt(  (VAR0*(img(i,j)-average).^2)/variance  );
            end
        end
    end
    output = img ;
end