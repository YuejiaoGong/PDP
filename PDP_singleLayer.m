function salMap = PDP_singleLayer(levelImg, superlabels, adjcMatrix, pixelList, levelIndex,RES, noSuffixName,frameRecord) 
    idxImg= superlabels{levelIndex};
    [h, w] = size(idxImg);
    smImg = imresize(levelImg, 0.4);
    smImg = double(smImg)/255;
    trans = CalDepthMap(smImg, 0.95, 5); 
    depthMap =  imresize(trans, [h w]);  
    minVal = min(depthMap(:));
    maxVal = max(depthMap(:));
    depthMap = (depthMap - minVal) / (maxVal - minVal + eps);        
%     imshow(depthMap);

    %% Get superpixel properties  
    %%%% the weights of features has small influence, comment by xxl
    spNum = size(adjcMatrix, 1);
    [meanPos, meanLabCol, meanDepth] = ...
                  GetSuperpixelProperties(pixelList, spNum, h, w, levelImg, depthMap);
    bdIds = GetBndPatchIds(idxImg);
    histLab = GetLabHist(pixelList, levelImg, spNum);
    colDistM1 = GetDistanceMatrix(meanLabCol);
    colDistM =  (GetDistanceMatrix(meanLabCol) + GetX2DistanceMatrix(histLab) * 10)/2;
    posDistM = GetDistanceMatrix(meanPos);
    histWLD = GetWLDFeatures(pixelList, levelImg, spNum);
    histLM =  GetLMFeatures(pixelList, levelImg, spNum);
    texDistM = (GetX2DistanceMatrix(histLM) + GetX2DistanceMatrix(histWLD))/2;

    %% Main procedures    
    bdCon = BoundaryConnectivity(adjcMatrix, colDistM1, bdIds);
    [refDepthSharp, refDepthSoft] = RefineDepth(meanDepth, bdCon);
    bgProb = CalBackgroundProbability(refDepthSharp);
    [~,~,~,~, wCtrF]= CalForegroundContrast(colDistM, posDistM, texDistM, bgProb, refDepthSoft);    
     
    fusedCtr = SaliencyFusionViaOptimization(bgProb, wCtrF, adjcMatrix, bdIds, colDistM, spNum);  
    salMap = CreateImageFromSPs(fusedCtr, pixelList, h, w, true);        
end

