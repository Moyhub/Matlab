function temp = temp()
      % 去除与主干线不相连的短 
%     for r = 1:length(row)
%         ii = row(r);
%         jj = col(r);
%         kk = depth(r);
%         count = 1;   %计数标志
%         node_temp = ones(10,3);
%         for s = 1:10
%           if(SimpleNode(img_thin_temp,ii,jj,kk) ~= 1)
%             img_thin_temp(ii,jj,kk) = 0;      %不算本身点去找下一个点
%             img_block = img_thin_temp(ii-1:ii+1,jj-1:jj+1,kk-1:kk+1);      %周围26连通点    
%             [i_temp,j_temp,k_temp] = ind2sub([3,3,3],find(img_block));     %获得在本身26连通域中的位置
%             i_temp = i_temp(1) + ii-2;
%             j_temp = j_temp(1) + jj-2;
%             k_temp = k_temp(1) + kk-2; 
%           else
%               i_temp = ii;
%               j_temp = jj;
%               k_temp = kk;
%           end
%             if(any(row == i_temp)==1 && any(col == j_temp) ==1 && any(depth == k_temp)==1 && count<10 ) %判断下一个点是不是端点
%                for t = 1:10
%                   img_thin(node_temp(t,1),node_temp(t,2),node_temp(t,3)) = 0;
%                end
%                break;
%             else
%                 if(count<10)
%                   node_temp(count,1) = i_temp;
%                   node_temp(count,2) = j_temp;
%                   node_temp(count,3) = k_temp;
%                   count = count + 1;
%                   ii = i_temp;
%                   jj = j_temp;
%                   kk = k_temp;
%                 else
%                     break;
%                 end
%             end
%         end
%     end    % 去除与主干线不相连的短 
%     for r = 1:length(row)
%         ii = row(r);
%         jj = col(r);
%         kk = depth(r);
%         count = 1;   %计数标志
%         node_temp = ones(10,3);
%         for s = 1:10
%           if(SimpleNode(img_thin_temp,ii,jj,kk) ~= 1)
%             img_thin_temp(ii,jj,kk) = 0;      %不算本身点去找下一个点
%             img_block = img_thin_temp(ii-1:ii+1,jj-1:jj+1,kk-1:kk+1);      %周围26连通点    
%             [i_temp,j_temp,k_temp] = ind2sub([3,3,3],find(img_block));     %获得在本身26连通域中的位置
%             i_temp = i_temp(1) + ii-2;
%             j_temp = j_temp(1) + jj-2;
%             k_temp = k_temp(1) + kk-2; 
%           else
%               i_temp = ii;
%               j_temp = jj;
%               k_temp = kk;
%           end
%             if(any(row == i_temp)==1 && any(col == j_temp) ==1 && any(depth == k_temp)==1 && count<10 ) %判断下一个点是不是端点
%                for t = 1:10
%                   img_thin(node_temp(t,1),node_temp(t,2),node_temp(t,3)) = 0;
%                end
%                break;
%             else
%                 if(count<10)
%                   node_temp(count,1) = i_temp;
%                   node_temp(count,2) = j_temp;
%                   node_temp(count,3) = k_temp;
%                   count = count + 1;
%                   ii = i_temp;
%                   jj = j_temp;
%                   kk = k_temp;
%                 else
%                     break;
%                 end
%             end
%         end
%     end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%去除一些多余分叉点%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     number = 1;
%     for t1 = 1:30
%      for m = number:length(row2)
%         mrow = row2(m);
%         mcol = col2(m);
%         mdepth = depth2(m);
%         distan = 255 * ones(1,length(row2));
%         for n = 1:length(row2)
%             nrow = row2(n);
%             ncol = col2(n);
%             ndepth = depth2(n);
%             distan(1,n) = abs(mrow-nrow) + abs(mcol-ncol) +abs(mdepth-ndepth);
%         end
%         [A1,index2] = sort(distan(:));
%         if(A1(2,1) < 10)
%             row2(m) = 1000;
%             col2(m) = 1000;
%             depth2(m) = 1000;
%             number = m;
%             break;
%         else
%             continue;
%         end
%      end
%     end
%     s=1;
%     for u = 1:length(row2)
%         if(row2(u)~=1 || col2(u)~=1 || depth2(u)~=1)
%            row3(s) = row2(u);
%            col3(s) = col2(u);
%            depth3(s) = depth(u);
%         end
%     end
%     length(row2(:))