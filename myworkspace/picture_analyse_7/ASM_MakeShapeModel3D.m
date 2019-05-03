function [ShapeData,TrainingData]= ASM_MakeShapeModel3D(TrainingData)

%TrainingData = load('LV_data\5-018-lvbd.txt');
% Number of datasets
s=length(TrainingData);

% Number of landmarks
nl = size(TrainingData(1).Vertices,1); %(86,3)

%% Shape model

% Remove rotation and translation   %�Ƴ���ת��ƽ��
% (Procrustes analysis would also be possible, see AAM_align_data)
MeanVertices=TrainingData(1).Vertices; %��һ�����ݵĶ���
offsetryz=0; offsetrxy=0; offsetV=[0 0 0];
for i=1:s
    [TrainingData(i).CVertices, TrainingData(i).tform]=ASM_align_data3D(TrainingData(i).Vertices,MeanVertices);
    offsetV=offsetV+TrainingData(i).tform.offsetV;
    offsetrxy=offsetrxy+TrainingData(i).tform.offsetrxy;
    offsetryz=offsetryz+TrainingData(i).tform.offsetryz;
end
MeantForm.offsetV=offsetV/s; 
MeantForm.offsetrxy=offsetrxy/s;
MeantForm.offsetryz=offsetryz/s;

% Construct a matrix with all contour point data of the training data set
% ��ѵ�����ݼ����������������ݹ���һ������
%TrainingData(i).CVertices  ����һ��86*3������
x=zeros(nl*3,s);
for i=1:length(TrainingData)
    x(:,i)=[TrainingData(i).CVertices(:,1);TrainingData(i).CVertices(:,2);TrainingData(i).CVertices(:,3)];
end
%X��258*140
[Evalues, Evectors, x_mean]=PCA(x);  %����ֵ������������ƽ��ѵ������

% Keep only 98% of all eigen vectors, (remove contour noise)
i=find(cumsum(Evalues)>sum(Evalues)*0.98,1,'first');  %i=32 ��ά
Evectors=Evectors(:,1:i);
Evalues=Evalues(1:i);

% Store the Eigen Vectors and Eigen Values
ShapeData.Evectors=Evectors;
ShapeData.Evalues=Evalues;
ShapeData.x_mean=x_mean;
ShapeData.x=x;
ShapeData.MeanVertices = MeanVertices;
ShapeData.MeantForm =MeantForm;





