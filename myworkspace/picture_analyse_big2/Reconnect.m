function img = Reconnect(img_thin_temp1,i1,j1,k1,i3,j3,k3)
    %�������ǲ�ȡһ�����ƵĵϽ�˹�������㷨��������
    %���ǿ���ö˵��26��ͨ����һ�������������ϵĵ��������������£�λ�ø��£�������Ѱ��һ�����·��
    %��ν��̣�������ӵĵ����١�
    %i1ϵ��Ϊ�˵㣬i3ϵ��Ϊ���ɵ�
    P2 = [i3,j3,k3];
    Max = abs(i1 - i3) + abs(j1 - j3) + abs(k1 - k3); %�������ѭ������
    position = ones(Max,3); %����λ�þ���
    dis = zeros(3,3,3); %���þ������
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
        position(t,1) = r2;position(t,2) = c2;position(t,3) = d2; %�����
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
        
    
    
    
    
     