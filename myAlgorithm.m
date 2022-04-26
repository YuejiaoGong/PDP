clear, clc, 
close all

%% 1. Parameter Settings
dataset = 'ECSSD';
algname = 'myAlg';
SRC = ['Data\',dataset,'\Imgs'];                %Path of input images
RES = ['Data\',dataset,'\saliency_',algname];   %Path for saving saliency maps
srcSuffix = '.jpg';                             %suffix for your input image

if ~exist(RES, 'dir')
    mkdir(RES);
end
addpath(genpath('Funcs'));
%addpath(genpath('Ppcs'));

%% 2. Saliency Map Calculation
files = dir(fullfile(SRC, strcat('*', srcSuffix)));

for k=1:length(files)
    
    srcName = files(k).name;
    noSuffixName = srcName(1:end-length(srcSuffix));
    disp(k); disp(srcName);
    
    %% Preprocessing: remove image frames
    srcImg = imread(fullfile(SRC, srcName));
    [noFrameImg, frameRecord] = removeframe(srcImg, 'sobel');
    [h, w, chn] = size(noFrameImg);
    
    %% Get depth map
    smImg = imresize(noFrameImg, 0.4);
    smImg = double(smImg)/255;
    trans = CalDepthMap(smImg, 0.95, 5); 
    depthMap =  imresize(trans, [h w]);  
    minVal = min(depthMap(:));
    maxVal = max(depthMap(:));
    depthMap = (depthMap - minVal) / (maxVal - minVal + eps);        
    
    %% Segment input rgb image into superpixels
    pixNumInSP = 600;                          %pixels in each superpixel
    spnumber = round( h * w / pixNumInSP );     %super-pixel number for current image
    [idxImg, adjcMatrix, pixelList] = SLIC_Split(noFrameImg, spnumber);
        
    %% Get superpixel properties
    spNum = size(adjcMatrix, 1);
    [meanPos meanRgbCol meanLabCol meanDepth spSizePb] = ...
                  GetSuperpixelProperties(pixelList, spNum, h, w, noFrameImg, depthMap);
    bdIds = GetBndPatchIds(idxImg);
    colDistM = GetDistanceMatrix(meanLabCol);
    posDistM = GetDistanceMatrix(meanPos);
    texDistM = GetWLDFeatures(pixelList, noFrameImg, spNum);
    
    %% Main procedures    
    bdCon = BoundaryConnectivity(adjcMatrix, colDistM, bdIds);
    [refDepthSharp refDepthSoft] = RefineDepth(meanDepth, bdCon);

    bgProb = CalBackgroundProbability(refDepthSharp);
    %depDistM = GetDistanceMatrix(refDepth);
    bgProbName = ['_bgProbD_',algname,'.png'];
    smapName=fullfile(RES, strcat(noSuffixName,bgProbName));
    bgSal = 1 - SaveSaliencyMap(bgProb, pixelList, frameRecord, smapName, false, 1);
    
    [CtrC CtrD CtrT CtrF wCtrF]= CalForegroundContrast(colDistM, posDistM, texDistM, bgProb, refDepthSoft, meanPos);
    dpName = ['_wCtrF_',algname,'.png'];
    smapName=fullfile(RES, strcat(noSuffixName, dpName));
    fgSal = SaveSaliencyMap(wCtrF, pixelList, frameRecord, smapName, true);
    
    fusionType = 'optimization';
    fusedCtrName = ['_fusedCtr_',algname,'.png'];
    smapName=fullfile(RES, strcat(noSuffixName, fusedCtrName));
    switch fusionType
        case 'optimization'
            fusedCtr = SaliencyFusionViaOptimization(bgProb, wCtrF, adjcMatrix, bdIds, colDistM, spNum);
            %fusedCtr = contrastEnhance(fusedCtr);
%             template = calCtrGuassTemp(fusedCtr,meanPos);
%             fusedCtr = fusedCtr .* template;
            salMap = SaveSaliencyMap(fusedCtr, pixelList, frameRecord, smapName, true);
        case 'integration'
            salMap = SaliencyFusionViaIntegration(bgSal, fgSal, srcImg);
            imwrite(salMap, smapName);
    end
    FsalMap = PostProcessing2(salMap);
    dpName = ['_FINAL_',algname,'.png'];
    smapName=fullfile(RES, strcat(noSuffixName, dpName));
    imwrite(FsalMap, smapName);
    
   
   %% Print intermediate results
    % depthMap
%     dpName = ['_Depth_',algname,'.png'];
%     smapName=fullfile(RES, strcat(noSuffixName, dpName));
%     SaveSaliencyMap2(depthMap, frameRecord, smapName);
    
%     dpName = ['_DepthRefSoft_',algname,'.png'];
%     smapName=fullfile(RES, strcat(noSuffixName, dpName));
%     SaveSaliencyMap(refDepthSoft, pixelList, frameRecord, smapName, true);
    
    dpName = ['_CtrC_',algname,'.png'];
    smapName=fullfile(RES, strcat(noSuffixName, dpName));
    SaveSaliencyMap(CtrC, pixelList, frameRecord, smapName, true);
    
    dpName = ['_CtrD_',algname,'.png'];
    smapName=fullfile(RES, strcat(noSuffixName, dpName));
    SaveSaliencyMap(CtrD, pixelList, frameRecord, smapName, true);
    
    dpName = ['_CtrT_',algname,'.png'];
    smapName=fullfile(RES, strcat(noSuffixName, dpName));
    SaveSaliencyMap(CtrT, pixelList, frameRecord, smapName, true);
    
    dpName = ['_CtrF_',algname,'.png'];
    smapName=fullfile(RES, strcat(noSuffixName, dpName));
    SaveSaliencyMap(CtrF, pixelList, frameRecord, smapName, true);
    
    
%     CtrName = ['_Ctr_',algname,'.png'];
%     smapName=fullfile(RES, strcat(noSuffixName, CtrName));
%     SaveSaliencyMap(Ctr, pixelList, frameRecord, smapName, true);
    
%     wCtrName = ['_wCtrF_',algname,'.png'];
%     smapName=fullfile(RES, strcat(noSuffixName, wCtrName));
%     SaveSaliencyMap(wCtrF, pixelList, frameRecord, smapName, true);
    
end

