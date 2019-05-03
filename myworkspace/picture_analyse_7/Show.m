function Show(P)
    % P is a vector of N*3 
    % N is the number of points 
    % Each row represents the coordinates of a point
    
    [tri(:,1) tri(:,2) tri(:,3)] = textread('connectivity.txt','%d %d %d');
    tri = tri + 1;
    trimesh(tri,P(:,1),P(:,2), P(:,3));
end

