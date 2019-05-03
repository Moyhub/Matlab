function [SEG,ball] = KalmanFilterForTracking(PATH,name)
frame            = [];  % A video frame
detectedLocation = [];  % The detected location
label            = '';  % Label for the ball
utilities        = [];  % Utilities used to process the video
SEG              = [];
%%
param = getDefaultParameters();
function trackSingleObject(param)
  % 创建用于读取视频、检测移动对象和显示结果的实用程序。
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
        % 在首次检测到球时，通过创建卡尔曼滤波器初始化跟踪。
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
        predict(kalmanFilter);  %通过调用预测和校正来降低测量噪声。
        label = 'Corrected';
      else
        label = 'Predicted';
      end
    end
  end 
end
%%
% 覆盖所有视频帧得到轨迹
 param = getDefaultParameters(); 
 trackSingleObject(param);  % visualize the results
% param = getDefaultParameters();         
% param.motionModel = 'ConstantVelocity'; %从恒定加速度切换到恒定速度
% param.initialEstimateError = param.initialEstimateError(1:2); %切换运动模型后，降噪声规范项对应于加速度。
% param.motionNoise          = param.motionNoise(1:2);

% trackSingleObject(param);
% param = getDefaultParameters();  % get parameters that work well
% param.initialLocation = [0, 0];  % 不是基于实际检测的位置
% param.initialEstimateError = 100*ones(1,3); % 使用相对较小值

% trackSingleObject(param); 
% param = getDefaultParameters();
% param.segmentationThreshold = 0.0005; % smaller value resulting in noisy detections
% param.measurementNoise      = 12500;  % increase the value to compensate 
%                                       % for the increase in measurement nois
% trackSingleObject(param); % visualize the results
%%
function param = getDefaultParameters  % 默认卡尔曼参数
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
   grayImage = rgb2gray(frame);  %装换为灰度图
   if(name == '0.mp4')
       E = 5;
   else
       E = 2;
   end
   utilities.foregroundMask = step(utilities.foregroundDetector, grayImage);  %获得前景mask
   B = ones(E);
   mask = imerode(utilities.foregroundMask,B);  %腐蚀
   mask = imdilate(mask,B); %膨胀  
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
    detection = detection(1, :);   %为了简化轨迹只用第一个检测的物体
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
  %NumTrainingFrames 训练背景模型的初始视频帧数
  %MinimumBackgroundRatio 确定背景模型的阙值
  %NumGaussians 高斯模型参数
  utilities.foregroundDetector = vision.ForegroundDetector(...
    'NumTrainingFrames',60, 'InitialVariance', param.segmentationThreshold);
  %BoundingBoxOutputPort 返回边界值的坐标
  %AreaOutputPort 返回blob区域
  %CentroidOutputPort 返回质心坐标   
  utilities.blobAnalyzer = vision.BlobAnalysis('AreaOutputPort', false, ...
    'MinimumBlobArea', 10, 'CentroidOutputPort', true);
end

end