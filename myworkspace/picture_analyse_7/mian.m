%% ��ȡtxt����
file = dir('LV_data\*.txt');
TrainingData = [];
for n = 1 : length(file)
    path = ['LV_data\',file(n).name];
    a = load( path );
    TrainingData(n).Vertices = a;      %140��ѵ��ͼƬ��86*3ÿ������
end

%% ��ȡ���ɷ�
[ShapeData,TrainingData] = ASM_MakeShapeModel3D(TrainingData);

%% ��������ͼ
Evalues = ShapeData.Evalues/(sum(ShapeData.Evalues(:)))*100;
figure(1);bar(Evalues,0.8); %ÿ���ɷ���ռ����

%% ����ϵ��ͼ ֻ����ǰ�ĸ����ɷ�
figure(2);
for i = 1 : 3
    subplot(2,3,i);
    Co_positive =ShapeData.x_mean + 100* ShapeData.Evectors(:,i);%Evector ����������Э������������ֵ�ֽ�ֵ��
    Co_positive_3D(:,1) = Co_positive(1:86);
    Co_positive_3D(:,2) = Co_positive(87:172);
    Co_positive_3D(:,3) = Co_positive(173:258);
    Show(Co_positive_3D);title(['��ϵ��','���ɷ�',num2str(i)]);
    subplot(2,3,i+3);
    Co_negetive =ShapeData.x_mean - 100* ShapeData.Evectors(:,i);
    Co_negetive_3D(:,1) = Co_negetive(1:86);
    Co_negetive_3D(:,2) = Co_negetive(87:172);
    Co_negetive_3D(:,3) = Co_negetive(173:258);
    Show(Co_negetive_3D);title(['��ϵ��','���ɷ�',num2str(i)]);
end

%% ʹ�����ɷֽ����ؽ�
figure(3);
x_mean_3D(:,1) = ShapeData.x_mean(1:86);
x_mean_3D(:,2) = ShapeData.x_mean(87:172);
x_mean_3D(:,3) = ShapeData.x_mean(173:258);
Show(x_mean_3D);title('ƽ��ͼ');
figure(4);
Num = 32;  %ʹ��ǰNUM�����ɷֽ����ؽ�
%�Ե�һ��ͼƬ�����ؽ�
picturenum = 50; %׼���ؽ� �ڼ���ͼ
x = [TrainingData(picturenum).CVertices(:,1);TrainingData(picturenum).CVertices(:,2);TrainingData(picturenum).CVertices(:,3)];
Img = (  (x-ShapeData.x_mean)' *(ShapeData.Evectors(:,1:Num)) * (ShapeData.Evectors(:,1:Num))' )' + ShapeData.x_mean;
IMG(:,1) = Img(1:86);
IMG(:,2) = Img(87:172);
IMG(:,3) = Img(173:258);
subplot(1,2,1);Show(TrainingData(picturenum).Vertices);title('ԭͼ');
subplot(1,2,2);Show(IMG);title('�ؽ�ͼ');