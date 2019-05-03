function bool = DistanceNode(img,i,j,k)
    a = ones(3*3);
    d = cat(3,a,a,a);
    d
    img_chunk = img(i-1:i+1,j-1:j+1,k-1:k+1);
    img_chunk_mul = img_chunk .* d;
    series = sum(img_chunk_mul(:));
    if(series >= 1)
        bool = 1;
    end
end