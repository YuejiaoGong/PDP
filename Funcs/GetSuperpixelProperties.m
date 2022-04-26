function [meanPos,  meanLabCol, meanDepth] = GetSuperpixelProperties(pixelList, spNum, height, width, Image, depthImg)

%spNum = length(pixelList);
meanPos = zeros(spNum, 2);

[h, w, chn] = size(Image);
tmpRGB = reshape(Image, h*w, chn);
meanCol =zeros(spNum, chn);

%[h, w] = size(depthImg);
tmpD=reshape(depthImg, h*w, 1);
meanDepth=zeros(spNum,1);

spSizePb=zeros(spNum,1);
meanSize = height * width / spNum;

for n = 1 : spNum
    [rows, cols] = ind2sub([height, width], pixelList{n});    
    meanPos(n,1) = mean(rows) / height;
    meanPos(n,2) = mean(cols) / width;
    meanCol(n, :)=mean(tmpRGB(pixelList{n},:), 1);
    meanDepth(n)=mean(tmpD(pixelList{n}));
    spSizePb(n) = length(pixelList{n})/meanSize;
end

if chn ==1 %for gray images
    meanCol = repmat(meanCol, [1, 3]);
end
meanLabCol = colorspace('Lab<-', double(meanCol)/255);
