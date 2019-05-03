function [SEG,ball] = KalmanFilterForTracking(PATH,name)
frame            = [];  % A video frame
detectedLocation = [];  % The detected location
label            = '';  % Label for the ball
utilities        = [];  % Utilities used to process the video
SEG              = [];
%%
param = getDefaultParameters();
function trackSingleObject(param)
  % �������ڶ�ȡ��Ƶ������ƶ��������ʾ�����ʵ�ó���
  utilities = createUtilities(param);
  isTrackInitialized = false; 
  idx = 1;
  while ~isDone(utilities.videoReader)
    frame = readFrame();
    ball = frame; 
    [detectedLocation, isObjectDetected] = detectObject(frame,idx);
    idx = idx + 1;
    if ~isTrackInitialized
      if isObjectDetected
        % ���״μ�⵽��ʱ��ͨ�������������˲�����ʼ�����١�
        initialLocation = computeInitialLocation(param, detectedLocation);
        kalmanFilter = configureKalmanFilter(param.motionModel, ...
        initialLocation, param.initialEstimateError, ...
        param.motionNoise, param.measurementNoise);
        isTrackInitialized = true;
        label = 'Initial';
      else
        label = '';
      end
    else
      if isObjectDetected  
        predict(kalmanFilter);  %ͨ������Ԥ���У�������Ͳ���������
        label = 'Corrected';
      else
        label = 'Predicted';
      end
    end
  end 
end
%%
% ����������Ƶ֡�õ��켣
 param = getDefaultParameters(); 
 trackSingleObject(param);  % visualize the results
% param = getDefaultParameters();         
% param.motionModel = 'ConstantVelocity'; %�Ӻ㶨���ٶ��л����㶨�ٶ�
% param.initialEstimateError = param.initialEstimateError(1:2); %�л��˶�ģ�ͺ󣬽������淶���Ӧ�ڼ��ٶȡ�
% param.motionNoise          = param.motionNoise(1:2);

% trackSingleObject(param);
% param = getDefaultParameters();  % get parameters that work well
% param.initialLocation = [0, 0];  % ���ǻ���ʵ�ʼ���λ��
% param.initialEstimateError = 100*ones(1,3); % ʹ����Խ�Сֵ

% trackSingleObject(param); 
% param = getDefaultParameters();
% param.segmentationThreshold = 0.0005; % smaller value resulting in noisy detections
% param.measurementNoise      = 12500;  % increase the value to compensate 
%                                       % for the increase in measurement nois
% trackSingleObject(param); % visualize the results
%%
function param = getDefaultParameters  % Ĭ�Ͽ���������
  param.motionModel           = 'ConstantAcceleration';
  param.initialLocation       = 'Same as first detection';
  param.initialEstimateError  = 1E5 * ones(1, 3);
  param.motionNoise           = [25, 10, 1];
  param.measurementNoise      = 25;
  param.segmentationThreshold = 0.05;
end
%%
function frame = readFrame()
  frame = step(utilities.videoReader);
end

%%
function [detection, isObjectDetected,mask] = detectObject(frame,idx)
   grayImage = rgb2gray(frame);  %װ��Ϊ�Ҷ�ͼ
   if(name == '0.mp4')
       E = 5;
   else
       E = 2;
   end
   utilities.foregroundMask = step(utilities.foregroundDetector, grayImage);  %���ǰ��mask
   B = ones(E);
   mask = imerode(utilities.foregroundMask,B);  %��ʴ
   mask = imdilate(mask,B); %����  
   mask = imopen(mask, strel('rectangle', [3,3]));
   mask = imclose(mask, strel('rectangle', [15, 15])); 
   mask = imfill(mask, 'holes');
  % figure(100);imshow(mask);
   if(name ~= '0.mp4')
       Connected = bwlabeln(mask,4); 
       for k = 1:20 
           dlag = size(find(Connected ==k),1);
           if(dlag > 120 || dlag < 14)
               for i = 1: size(mask,1)
                   for j = 1:size(mask,2)
                      if(Connected(i,j) == k)
                         mask(i,j) = 0; 
                      end
                   end
               end
           end
       end
   end  
 % figure(101);imshow(mask);
  SEG(idx,:,:) = mask;
  detection = step(utilities.blobAnalyzer,mask );
  if isempty(detection)
    isObjectDetected = false;
  else
    detection = detection(1, :);   %Ϊ�˼򻯹켣ֻ�õ�һ����������
    isObjectDetected = true;
  end
end

function loc = computeInitialLocation(param, detectedLocation)
  if strcmp(param.initialLocation, 'Same as first detection')
    loc = detectedLocation;
  else
    loc = param.initialLocation;
  end
end
%%
function utilities = createUtilities(param)
  utilities.videoReader = vision.VideoFileReader(PATH);
  %NumTrainingFrames ѵ������ģ�͵ĳ�ʼ��Ƶ֡��
  %MinimumBackgroundRatio ȷ������ģ�͵���ֵ
  %NumGaussians ��˹ģ�Ͳ���
  utilities.foregroundDetector = vision.ForegroundDetector(...
    'NumTrainingFrames',60, 'InitialVariance', param.segmentationThreshold);
  %BoundingBoxOutputPort ���ر߽�ֵ������
  %AreaOutputPort ����blob����
  %CentroidOutputPort ������������   
  utilities.blobAnalyzer = vision.BlobAnalysis('AreaOutputPort', false, ...
    'MinimumBlobArea', 10, 'CentroidOutputPort', true);
end

end