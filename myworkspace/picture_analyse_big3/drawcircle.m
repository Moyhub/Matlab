function ballground_final = drawcircle(ballground,c,r)
    s = size(ballground);
    ballground = zeros(s);
    
    for j = 1: s(1)
        for i = 1:s(2)
            dis = norm([i,j]-c);
            if(dis < r)
                ballground(j,i) = 1;
            end
        end
    end
    ballground_final = ballground;
      figure(3);
      imshow(ballground_final);
end
