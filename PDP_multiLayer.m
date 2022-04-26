function PDP_multiLayer(srcImg, multiscale, algName, RES, noSuffixName)

    %% Preprocessing: remove image frames
    [sh, sw, scn] = size(srcImg);
    [noFrameImg, frameRecord] = removeframe(srcImg, 'sobel');
    [h, w, cn] = size(noFrameImg);
    superlabels = cell(length(multiscale),1);
    superAdjc = cell(length(multiscale),1);
    superpList = cell(length(multiscale),1);
    %% Segment input image into superpixels
    for scale=1:length(multiscale)
        [idxImg, adjcMatrix, pixelList] = SLIC_Split(noFrameImg, multiscale(scale));
        superlabels{scale} = idxImg;
        superAdjc{scale} =adjcMatrix;
        superpList{scale} =pixelList;
    end
  
    %% Calculate the Saliency Map for each Level
    sumMap = zeros(sh, sw);
    for ind = 1 : length(multiscale)
       %figure;imshow(layers(ind).img);
       localMap = PDP_singleLayer(noFrameImg,superlabels,superAdjc{ind}, superpList{ind}, ind,RES, noSuffixName,frameRecord);   
       globalMap = imresize(localMap, [h w]);      
       levelMap = RecoverFrame(globalMap, frameRecord);    
       sumMap = sumMap + levelMap;
    end
    sumMap = sumMap ./  length(multiscale);
    minVal = min(min(sumMap));
    maxVal = max(max(sumMap));
    sumMap = (sumMap - minVal) / (maxVal - minVal + eps);
    
    dpName = ['_withoutPost_',algName,'.png'];
    smapName=fullfile(RES, strcat(noSuffixName, dpName));
    imwrite(sumMap, smapName);
    
    postMap = PostProcessing(sumMap);
    dpName = ['_',algName,'.png'];
    smapName=fullfile(RES, strcat(noSuffixName, dpName));
    imwrite(postMap, smapName);
        
end

