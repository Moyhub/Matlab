function img = Reconnect(img_thin_temp1,i1,j1,k1,i3,j3,k3)
    %这里我们采取一种类似的迪杰斯特拉的算法进行重连
    %我们考察得端点的26连通域，哪一个点离主干线上的点最近，将距离更新，位置更新，即可搜寻出一条最短路径
    %所谓最短，就是添加的点最少。
    %i1系列为端点，i3系列为主干点
    P2 = [i3,j3,k3];
    Max = abs(i1 - i3) + abs(j1 - j3) + abs(k1 - k3); %设置最多循环次数
    position = ones(Max,3); %设置位置矩阵
    dis = zeros(3,3,3); %设置距离矩阵
 for t = 1:Max
  if(i1>2 && j1>2 && k1>2)
    for i = i1-1:i1+1
        for j = j1-1:j1+1
            for k = k1-1:k1+1
                P1 = [i,j,k];
                dis(i-i1+2,j-j1+2,k-k1+2) = norm(P1 - P2);
            end
        end
    end
    [r,c,d] = ind2sub( [3,3,3],find(dis == min(dis(:))) );
    if(min(dis(:)==0))
        break;
    else
        r2 = r(1)+ i1-2;
        c2 = c(1)+ j1-2;
        d2 = d(1)+ k1-2;
        i1 = r2;
        j1 = c2;
        k1 = d2;
        position(t,1) = r2;position(t,2) = c2;position(t,3) = d2; %保存点
    end
  end
 end
   for g = 1:Max
       if( position(g,1)==1 && position(g,2)==1 && position(g,3)==1 )
           continue;
       else
          img_thin_temp1(position(g,1),position(g,2),position(g,3)) = 1;
       end
   end
   img = img_thin_temp1;
end
        
    
    
    
    
     