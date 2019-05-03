%% 读取txt数据
file = dir('LV_data\*.txt');
TrainingData = [];
for n = 1 : length(file)
    path = ['LV_data\',file(n).name];
    a = load( path );
    TrainingData(n).Vertices = a;      %140张训练图片，86*3每张数据
end

%% 提取主成分
[ShapeData,TrainingData] = ASM_MakeShapeModel3D(TrainingData);

%% 画出能量图
Evalues = ShapeData.Evalues/(sum(ShapeData.Evalues(:)))*100;
figure(1);bar(Evalues,0.8); %每个成分所占比例

%% 正负系数图 只画出前四个主成分
figure(2);
for i = 1 : 3
    subplot(2,3,i);
    Co_positive =ShapeData.x_mean + 100* ShapeData.Evectors(:,i);%Evector 特征向量（协方差矩阵的奇异值分解值）
    Co_positive_3D(:,1) = Co_positive(1:86);
    Co_positive_3D(:,2) = Co_positive(87:172);
    Co_positive_3D(:,3) = Co_positive(173:258);
    Show(Co_positive_3D);title(['正系数','主成分',num2str(i)]);
    subplot(2,3,i+3);
    Co_negetive =ShapeData.x_mean - 100* ShapeData.Evectors(:,i);
    Co_negetive_3D(:,1) = Co_negetive(1:86);
    Co_negetive_3D(:,2) = Co_negetive(87:172);
    Co_negetive_3D(:,3) = Co_negetive(173:258);
    Show(Co_negetive_3D);title(['负系数','主成分',num2str(i)]);
end

%% 使用主成分进行重建
figure(3);
x_mean_3D(:,1) = ShapeData.x_mean(1:86);
x_mean_3D(:,2) = ShapeData.x_mean(87:172);
x_mean_3D(:,3) = ShapeData.x_mean(173:258);
Show(x_mean_3D);title('平均图');
figure(4);
Num = 32;  %使用前NUM个主成分进行重建
%对第一张图片进行重建
picturenum = 50; %准备重建 第几张图
x = [TrainingData(picturenum).CVertices(:,1);TrainingData(picturenum).CVertices(:,2);TrainingData(picturenum).CVertices(:,3)];
Img = (  (x-ShapeData.x_mean)' *(ShapeData.Evectors(:,1:Num)) * (ShapeData.Evectors(:,1:Num))' )' + ShapeData.x_mean;
IMG(:,1) = Img(1:86);
IMG(:,2) = Img(87:172);
IMG(:,3) = Img(173:258);
subplot(1,2,1);Show(TrainingData(picturenum).Vertices);title('原图');
subplot(1,2,2);Show(IMG);title('重建图');