function bool = SimpleNode(img,i,j,k) 
    bool=0;
    img_chunk = img(i-1:i+1,j-1:j+1,k-1:k+1);
    img_chunk(2,2,2) = 0;
    if(img_chunk == 0)
        bool = 1;
    else
        bool = 0;
    end
end