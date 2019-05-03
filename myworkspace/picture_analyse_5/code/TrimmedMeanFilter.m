function J = TrimmedMeanFilter(I,hsize,d)

J = nlfilter(I,[hsize hsize],@iTrimmedMeanFilter);

    function y = iTrimmedMeanFilter(x)
    x2 = sort(x(:));
    n = floor(d/2);
    x3 = x2(n+1:end-n);
    y = mean(x3);
    end
end