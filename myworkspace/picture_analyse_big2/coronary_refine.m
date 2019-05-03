function [] = coronary_refine( )
% 该函数处理'rpath'下的每个冠状动脉概率图。 
%处理步骤包括但不限于阈值处理，填充孔，减薄，检测分叉或终点，重新连接断开的分支，去除分离的分支，并最终获得冠状动脉树。
% Examples:
% coronary_refine('path_of_parent_directory_containg_volumes')
% create output directory
close all;
rpath = '';
wpath = fullfile(rpath, 'coronary');            %合并成一个完整路径
if ~exist(wpath, 'dir'), mkdir(wpath); end
%%%%%%%%%%%%%%%%%%%%%%%如果想看中间过程图，将名称改成如下形式%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
img_list = dir(fullfile(rpath, '*.mha')); %读取图片
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for  ii= 1:length(img_list)
    %% read mha volume 
    img_path = fullfile(rpath, img_list(ii).name);
    [img_prop, img_info] = mha_read_volume(img_path); 
    %% thresholdingCoro
    img_bin = img_prop >= (0.5*intmax('uint16'));     %阙值分割（二值化）
    volumeViewer(img_bin);
    w_info = img_info; % header information of volume to be written
    w_info.DataType = 'uchar'; % change the data type to uchar (uint8)
    mha_write(img_bin, w_info, 'path'); 
    %% filling holes  
    img_bin = imfill(img_bin,'holes');    %空洞填充  
     %对每一片都进行空洞填充
    for i = 1:size(img_bin,3)
        img_bin(:,:,i) = imfill(img_bin(:,:,i),'holes');
    end
    for i = 1:size(img_bin,2)
        img_bin(:,i,:) = imfill(squeeze(img_bin(:,i,:)),'holes'); %医学图像取其他维度
    end
    for i = 1:size(img_bin,1)
        img_bin(i,:,:) = imfill(squeeze(img_bin(i,:,:)),'holes');
    end
    img_thin = (img_bin);
    %volumeViewer(img_bin);
    figure(1);
    [cpt_x, cpt_y, cpt_z] = ind2sub(size(img_thin), find(img_thin));
    plot3(cpt_x, cpt_y, cpt_z, '.r');title('原图','fontname','仿宋','FontSize',14,'Color','r');
    %% thinning
    %通过将冠状动脉的中心线视为一组点来绘制冠状动脉的中心线
    %提取骨架工具箱算法
    img_thin = bwskel(img_thin);    
    %以下是对每一个维度进行细化，不过效果和骨架算法得到的结果差不多，仅仅去掉几个多余点而已 
    for i = 1:size(img_thin,3)  
          img_thin(:,:,i) = bwmorph(img_thin(:,:,i),'thin',20);
    end
    for i = 1:size(img_thin,2)
          img_thin(:,i,:) = bwmorph(squeeze(img_thin(:,i,:)),'thin',20);
    end
    for i = 1:size(img_thin,1)
          img_thin(i,:,:) = bwmorph(squeeze(img_thin(i,:,:)),'thin',20);
    end
    figure(2);
    [cpt_x, cpt_y, cpt_z] = ind2sub(size(img_thin), find(img_thin));
    plot3(cpt_x, cpt_y, cpt_z, '.r'); title('细化得到的结果(未擦除毛刺和断枝)','fontname','仿宋','FontSize',14,'Color','r');    
   %% 检测端点和分叉点，并擦除毛刺和短线
    % 搜寻端点
for k = 1:50
    Endpoints = bwmorph3(img_thin,'endpoints');
    [row,col,depth] = ind2sub(size(img_thin),find(Endpoints));
    % 搜寻临时分叉点（去除毛刺用,毛刺不是很多）
    Branchpoints_temp = bwmorph3(img_thin,'branchpoints'); 
    [row1,col1,depth1] = ind2sub(size(img_thin),find(Branchpoints_temp)); %寻找分叉点的坐标
    distance = 255*ones(1,length(row1));
    for i = 1:length(row)
        for j = 1:length(row1) 
            distance(1,j) = abs(row(i)-row1(j)) + abs(col(i) - col1(j)) + abs(depth(i) - depth1(j));
        end
        [~,index] = sort(distance(:));
        [~,result_findc] = ind2sub(size(distance),index(1));%找到是第几个分叉点离第i个端点最近
        if(distance(1,result_findc) <= 20)
            img_thin(row(i),col(i),depth(i)) = 0;
        end
    end  
end
    %去除图片中的一些与主干线不相连的短线
 for K = 1:20
    Endpoints = bwmorph3(img_thin,'endpoints');
    [row,col,depth] = ind2sub(size(img_thin),find(Endpoints));
    distance = 255*ones(1,length(row));
    for i = 1:length(row)
        for j = 1:length(row) 
            distance(1,j) = abs(row(i)-row(j)) + abs(col(i) - col(j)) + abs(depth(i) - depth(j));
        end
        [~,index] = sort(distance(:));
        [~,result_findc] = ind2sub(size(distance),index(2));%找到是第几个端点离第i个端点最近
        if(distance(1,result_findc) <= 20)
            img_thin(row(i),col(i),depth(i)) = 0;
        end
    end  
 end
%去除一些图片中的单点和一些单维远点
    rr = 0;
    for rr = 2:size(img_thin,1)
        for jj = 2:size(img_thin,2)
            for kk = 2:size(img_thin,3)
                if(img_thin(rr,jj,kk)~=0)
                    if( SimpleNode(img_thin,rr,jj,kk)==1 ) %||  DistanceNode(img_thin,ii,jj,kk)==1 )
                        img_thin(rr,jj,kk) = 0;
                    end
                end
            end
        end
    end
%显示
    figure(3);
    [cpt_x, cpt_y, cpt_z] = ind2sub(size(img_thin), find(img_thin));
    plot3(cpt_x, cpt_y, cpt_z, '.r'); title('去除毛刺与短分支','fontname','仿宋','FontSize',14,'Color','r');   
    
    %% 显示端点和分拆点
    figure(4);
    [cpt_x, cpt_y, cpt_z] = ind2sub(size(img_thin), find(img_thin));
    plot3(cpt_x, cpt_y, cpt_z, '.r'); title('显示端点(未修复)','fontname','仿宋','FontSize',14,'Color','r');
    endpoint = bwmorph3(img_thin,'endpoints');
    [row,col,depth] = ind2sub(size(img_thin),find(endpoint));
    hold on, plot3(row,col,depth,'ms','MarkerSize',10);
    %显示最终分叉点
    figure(5);
    [cpt_x, cpt_y, cpt_z] = ind2sub(size(img_thin), find(img_thin));
    plot3(cpt_x, cpt_y, cpt_z, '.r'); title('显示分叉点(未修复)','fontname','仿宋','FontSize',14,'Color','r');
    branchpoints = bwmorph3(img_thin,'branchpoints');
    [row,col,depth] = ind2sub(size(img_thin),find(branchpoints));
    hold on, plot3(row,col,depth,'bs','MarkerSize',10); 
%%
    %reconnecting disconnected branches & removing isolate points or branches
    %因为存在一些距离主干线十分近的较长枝段，这里将使用最小代价路径算法将较长枝段连接到主干线上
    endpoint = bwmorph3(img_thin,'endpoints');
    [row,col,depth] = ind2sub(size(img_thin),find(endpoint));
    img_thin_temp1 = img_thin;
    Connected = bwlabeln(img_thin_temp1,26);  %找到连通域
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %用这种方式[sss,ttt,rrr] = ind2sub([450,450,287],find(Connected ==n));
    %66图  判断出一共有9个连通域，32/32/26/284/35/14/120/603/41。
    %其实用连通域方法去除短线更好，前一天晚上没有想到
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i1 = 1:length(row)
        i1_r = row(i1);
        j1_c = col(i1);         
        k1_d = depth(i1); 
        flag = Connected(i1_r,j1_c,k1_d); %看这个端点属于哪个连通域
        dis = 255*ones(1,length(cpt_x)); %设定初始值，同时保证不会成为排序后的第一个
        for i2 = 1:length(cpt_x)
            i2_r = cpt_x(i2);     %在坐标轴内的点坐标
            j2_c = cpt_y(i2);
            k2_d = cpt_z(i2);
            if(Connected(i2_r,j2_c,k2_d) == flag) %如果是同一连通域
                continue;
            else
                dis(1,i2) =norm([i1_r,j1_c,k1_d]-[i2_r,j2_c,k2_d]);
            end
        end
        [A,INDEX] = sort(dis(:));
        i3_r = cpt_x(INDEX(1));
        j3_c = cpt_y(INDEX(1));
        k3_d = cpt_z(INDEX(1));    %找到最近的点
        if (A(1,1) > 20)
            continue;
        else
            img_thin_temp1 = Reconnect(img_thin_temp1,i1_r,j1_c,k1_d,i3_r,j3_c,k3_d);
        end
    end
    img_reconnected =img_thin_temp1;
    [~, ~, ~] = ind2sub(size(img_reconnected), find(img_reconnected));
    endpoint1 = bwmorph3(img_reconnected,'endpoints'); 
    [row_f,col_f,depth_f] = ind2sub(size(img_reconnected),find(endpoint1));
    %%
    %以下这段程序是连接与主干分支很远的孤立线条   
    %处理之后的连通分量仅存6个32/32/434/35/14/662
    for p = 1:length(row_f) 
        %每一次计算
        Connected2 = bwlabeln(img_reconnected,26);
        [row_f,col_f,depth_f] = ind2sub(size(img_reconnected),find(endpoint1));
        x = row_f(p);
        y = col_f(p);
        z = depth_f(p);
        dlag = Connected2(x,y,z);
        dista = 2550*ones(1,length(row_f));
        for q = 1:length(row_f)
            x1 = row_f(q);
            y1 = col_f(q);
            z1 = depth_f(q);
            if(Connected2(x1,y1,z1) == dlag)
                continue;
            else
                dista(1,q) = abs(x-x1)+abs(y-y1)+abs(z-z1);
            end
        end
        [A,index1] = sort(dista(:));
        if(A(1,1)>70)
            continue;
        else
            x2 = row_f(index1(1));
            y2 = col_f(index1(1));
            z2 = depth_f(index1(1));
            img_reconnected =  Reconnect_sec(img_reconnected,x,y,z,x2,y2,z2);
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%再次优化,去除毛刺%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for k = 1:10
    endpoints2 = bwmorph3(img_reconnected,'endpoints');
    [row,col,depth] = ind2sub(size(img_reconnected),find(endpoints2));
    branchpoints1 = bwmorph3(img_reconnected,'branchpoints'); 
    [row1,col1,depth1] = ind2sub(size(img_reconnected),find(branchpoints1)); %寻找分叉点的坐标
    distance = 255*ones(1,length(row1));
     for i = 1:length(row)
        for j = 1:length(row1) 
            distance(1,j) = abs(row(i)-row1(j)) + abs(col(i) - col1(j)) + abs(depth(i) - depth1(j));
        end
        [~,index] = sort(distance(:));
        [~,result_findc] = ind2sub(size(distance),index(1));%找到是第几个分叉点离第i个端点最近
        if(distance(1,result_findc) <= 20)
            img_reconnected(row(i),col(i),depth(i)) = 0;
        end
     end  
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%优化，删除游离在外无法连接的短线%%%%%%%%%%%%%%%%%%%%%%%%%
    if(img_list(ii).name == 'ours_066_c1.mha' )   %%这行代码只针对66图
       [b1,b2,b3] = ind2sub(size(img_reconnected),find(Connected2 == 1));
       img_reconnected(b1,b2,b3) = 0;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%去除一些多余分叉点%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    branchpoints2 = bwmorph3(img_reconnected,'branchpoints'); 
    [row2,col2,depth2] = ind2sub(size(img_reconnected),find(branchpoints2)); %寻找分叉点的坐标
    number = 1;
    for t1 = 1:30
     for m = number:length(row2)
        mrow = row2(m);
        mcol = col2(m);
        mdepth = depth2(m);
        distan = 255 * ones(1,length(row2));
        for n = 1:length(row2)
            nrow = row2(n);
            ncol = col2(n);
            ndepth = depth2(n);
            distan(1,n) = abs(mrow-nrow) + abs(mcol-ncol) +abs(mdepth-ndepth);
        end
        [A1,index2] = sort(distan(:));
        if(A1(2,1) < 10)
            row2(m) = 1000;
            col2(m) = 1000;
            depth2(m) = 1000;
            number = m;
            break;
        else
            continue;
        end
     end
    end
    s=1;
    for u = 1:length(row2)
        if(row2(u)~=1 || col2(u)~=1 || depth2(u)~=1)
           row3(s) = row2(u);
           col3(s) = col2(u);
           depth3(s) = depth2(u);
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%显示%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    figure(6);
    [cpt_x1, cpt_y1, cpt_z1] = ind2sub(size(img_reconnected), find(img_reconnected));
    plot3(cpt_x1, cpt_y1, cpt_z1, '.r'); title('重新连接效果图并显示端点','fontname','仿宋','FontSize',14,'Color','r');
    endpoints3 = bwmorph3(img_reconnected,'endpoints');
    [row,col,depth] = ind2sub(size(img_reconnected),find(endpoints3));
    hold on; plot3(row,col,depth,'ms','MarkerSize',10);
    figure(7);
    [cpt_x1, cpt_y1, cpt_z1] = ind2sub(size(img_reconnected), find(img_reconnected));
    plot3(cpt_x1, cpt_y1, cpt_z1, '.r'); title('重新连接效果图并显示分叉点','fontname','仿宋','FontSize',14,'Color','r');
    branchpoints1 = bwmorph3(img_reconnected,'branchpoints'); 
    [row2,col2,depth2] = ind2sub(size(img_reconnected),find(branchpoints1));
    hold on, plot3(row2,col2,depth2,'bs','MarkerSize',10); 
    
   %% 将采用寻找连通分量的算法，把去除分叉点后的每一个分量认为是一个线段
   %   将每个线段ID 分组 并打包成数组
    img_divide = img_reconnected;
    row_save = row2; col_save =col2; depth_save = depth2; %储存下来分叉点
    for y2 = 1:length(row2)
        y2_r = row2(y2);
        y2_c = col2(y2);
        y2_d = depth2(y2);
        img_divide(y2_r,y2_c,y2_d) = 0;
    end
    for rr = 2:size(img_divide,1)
        for jj = 2:size(img_divide,2)
            for kk = 2:size(img_divide,3)
                if(img_divide(rr,jj,kk)~=0)
                    if( SimpleNode(img_divide,rr,jj,kk)==1 )
                        img_divide(rr,jj,kk) = 0;
                    end
                end
            end
        end
    end
    Connected3 = bwlabeln(img_divide,26);
    for nn = 1:100           %找到有多少个连通分量
        [sss,ttt,rrr] = ind2sub([size(img_bin,1),size(img_bin,2),size(img_bin,3)],find(Connected3 ==nn));
        if(isempty(sss) ~=1)
            continue;
        else
            mm = nn-1;
            break;
        end
    end
    Liners = cell(mm,1);
    for hh = 1:mm
         [s2,t2,r2] = ind2sub([size(img_bin,1),size(img_bin,2),size(img_bin,3)],find(Connected3 ==hh));
         Liners{hh,1}(:,1) = s2;
         Liners{hh,1}(:,2) = t2;
         Liners{hh,1}(:,3) = r2;
    end
    coronary_show(Liners);
    hold on;  plot3(row_save, col_save, depth_save, '.r'); title('填补上分叉点','fontname','仿宋','FontSize',14,'Color','r');
   %coronary_show(coro_tree);
    %% save the tree obtained into a mat file (.mat
    tree_name = split(img_list(ii).name, '.');
    tree_name = [tree_name{1}, '.mat'];
    tree_path = fullfile(wpath, tree_name);
    save(tree_path, 'Liners');
end
 
end
