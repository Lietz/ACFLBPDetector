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
opts.name='F:/CJ/Codes/matlav/DollarsDemo/model/AcfInria';

%% load detector
cd(fileparts(which('2test.m')));
load('F:\CJ\Codes\matlav\DollarsDemo\model/acfInriaDetector.mat','detector');
% load('F:/CJ/Codes/Libraries/toolbox-master/detector/models/acfInriaDetector.mat','detector');

%% train detector (see acfTrain)
detector = acfTrain( opts );

%% modify detector (see acfModify)
pModify=struct('cascThr',-1,'cascCal',.01);
detector=acfModify(detector,pModify);

%% test on a simple img
% img = imread('inria_sample.png');
% bbs = acfDetect(img,detector); %return bounding boxes [x y w h score]
% imshow(img);
% bbApply('draw',bbs);

%% output all test pictures
dataDir='F:\CJ\DataSets\InriaDollar\INRIA';
outputDir='F:\CJ\DataSets\InriaDollar\output';
imgNms=bbGt('getFiles',{[dataDir 'test/pos']});
for i=1:length(imgNms)
    I=imread(imgNms{i});
    tic, bbs=acfDetect(I,detector); toc
   figure(1); im(I); bbApply('draw',bbs); %œ‘ æ
%     boxedI = bbApply( 'embed', I, bbs);  %¥Ê¥¢
%     savename=regexp(imgNms{i}, '\', 'split');savename=savename{7};%¥Ê¥¢
%     imwrite(boxedI,sprintf('%s\\%s',outputDir,savename)) %¥Ê¥¢
    pause(1);  
end

%% test detector and plot roc (see acfTest)
[miss,~,gt,dt]=acfTest('name',opts.name,'imgDir',[dataDir 'test/pos'],...
  'gtDir',[dataDir 'test/posGt'],'pLoad',opts.pLoad,...
  'pModify',pModify,'reapply',0,'show',2);

%% optional timing test for detector (should be ~30 fps)
if( 0 )
  detector1=acfModify(detector,'pad',[0 0]); n=60; Is=cell(1,n);
  for i=1:n, Is{i}=imResample(imread(imgNms{i}),[480 640]); end
  tic, for i=1:n, acfDetect(Is{i},detector1); end;
  fprintf('Detector runs at %.2f fps on 640x480 images.\n',n/toc);
end

%% optionally show top false positives ('type' can be 'fp','fn','tp','dt')
if( 0 ), bbGt('cropRes',gt,dt,imgNms,'type','fp','n',50,...
    'show',3,'dims',opts.modelDs([2 1])); end

