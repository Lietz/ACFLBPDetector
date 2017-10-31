% img = imread('inria_sample.png');
% load('detector/models/acfInriaDetector.mat','detector'); %load INRIA-trained detector
% bbs = acfDetect(img,detector); %return bounding boxes [x y w h score]
% imshow(img);
% bbApply('draw',bbs);
%% set paths
cd(fileparts(which('1train.m')));
dataDir='F:/CJ/DataSets/InriaDollar/INRIA';

%% set up opts for training detector (see acfTrain)
opts=acfTrain();
opts.modelDs=[100 41];% model height+width without padding (eg [100 41])
opts.modelDsPad=[128 64];% model height+width with padding (eg [128 64])
opts.posGtDir=[dataDir 'train/posGt']; % dir containing ground truth
opts.nWeak=[32 128 512 2048]; %[128] vector defining number weak clfs per stage
opts.posImgDir=[dataDir 'train/pos']; %dir containing full positive images
opts.pJitter=struct('flip',1);%[{}] params for jittering pos windows (see jitterImage)
opts.negImgDir=[dataDir 'train/neg']; %dir containing full negative images
% 'pBoost' specifies parameters for AdaBoost, and 'pBoost.pTree' are the
% decision tree parameters, see adaBoostTrain.m for details. Finally,
opts.pBoost.pTree.fracFtrs=1/16;% parameters for boosting (see adaBoostTrain.m)
opts.pLoad={'squarify',{3,.41}}; 
opts.name='F:/CJ/Codes/matlav/DollarsDemo/model/AcfInria';% defines the location for storing the detector and log file
%% train detector (see acfTrain)
detector = acfTrain( opts );
%% modify detector (see acfModify)
%   .cascThr    - [] constant cascade threshold (affects speed/accuracy)
%   .cascCal    - [] cascade calibration (affects speed/accuracy)
pModify=struct('cascThr',-1,'cascCal',.01);
detector=acfModify(detector,pModify);

%% run detector on a sample image (see acfDetect)
imgNms=bbGt('getFiles',{[dataDir 'test/pos']}); %所有图片地址
I=imread(imgNms{2}); 
tic, bbs=acfDetect(I,detector); toc %tic toc 计时
figure(1); im(I); bbApply('draw',bbs); pause(.1);

%% test detector and plot roc (see acfTest)
[miss,ROC,gt,dt]=acfTest('name',opts.name,'imgDir',[dataDir 'test/pos'],...
  'gtDir',[dataDir 'test/posGt'],'pLoad',opts.pLoad,...
  'pModify',pModify,'reapply',0,'show',2);


