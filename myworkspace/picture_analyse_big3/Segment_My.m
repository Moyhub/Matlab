function [background_re,x1,y1,r]  = Segment_My(frame,x,y,line,flag,x_hand,y_hand,NAME)
    if(NAME == '0.mp4')
        SH = 14;
    else
        SH = 4.9;
    end
    frame = im2double(rgb2gray(frame));  %��ֵ��
    s = size(frame);                     %�߶�
    Edge = edge(frame,'canny');
    %�õ���ֵͼ
    background = cell2mat(struct2cell(load('Video_data\1.mat')));     %���뱳��
    divide = abs(frame - background);    %�����ֵ
    average = mean(divide(:));
    variance = std(divide(:));
    ballground = divide > (average + 4 *variance) ; %�������ճ�ǰ���˶���ֵͼ 
    %��ʴ���Ͳ���
    B = ones(3);
    ballground = imerode(ballground,B);  %��ʴ
    ballground = imdilate(ballground,B); %����   
    %���Գ����켣������յ㲽��
    x_final = line(size(line,1)-1,1);
    y_final = line(size(line,1)-1,2);
    deletx =double( double(x_final - x_hand)/double(size(line,1)-2) ) ;
    delety =double( double(y_final - y_hand)/double(size(line,1)-2) ) ;
    %����һ��mask 
    background = zeros(s);
    ballground_final = zeros(s);
    if(flag < size(line,1) && flag > 1 )
        x1 = double( ceil(x_hand + (flag-1)*deletx) );
        y1 = double( ceil(y_hand + (flag-1)*delety) );
        c = [x1,y1];
        r = SH;
 %      drawcircle(ballground_final,c,r);
    else
        background(y-20:y+20,x-20:x+20) = ballground(y-20:y+20,x-20:x+20);  
        [c,r] = imfindcircles(background,[1,10]);  %��Բ  
        if( size(c,1) == 0 )
            c = [x,y];
            r = SH;
        end
        c = double(c);
        c(1) = c(1,1);
        c(2) = c(1,2);
        x1 = c(1);
        y1 = c(2);
 %     drawcircle(ballground_final,c,r);
    end     
    if(flag == 1)
        x1 = x;
        y1 = y;
        c = [x1,y1];
        r = SH;
        c = double(c);
 %    drawcircle(ballground_final,c,r);
    end     
      background_re = ballground;
%     figure(2),imshow(ballground);
%     hold on;
%     plot(x1,y1,'*r');
%     hold on
%     viscircles(c,r,'EdgeColor','b');
end