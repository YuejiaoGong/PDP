function SaveSaliencyMap_Img(partialImg,frameRecord, imgName, doNormalize, fill_value)
% Fill back super-pixel values to image pixels and save into .png images

% Code Author: Wangjiang Zhu
% Email: wangjiang88119@gmail.com
% Date: 3/24/2014


if (~ischar(imgName))
    error('imgName should be a string');
end

if (nargin < 4)
    doNormalize = true;
end

if (nargin < 5)
    fill_value = 0;
end

h = frameRecord(1);
w = frameRecord(2);

top = frameRecord(3);
bot = frameRecord(4);
left = frameRecord(5);
right = frameRecord(6);

partialH = bot - top + 1;
partialW = right - left + 1;

minVal = min(min(partialImg));
maxVal = max(max(partialImg));
if doNormalize
    partialImg = (partialImg - minVal) / (maxVal - minVal + eps);
end

if partialH ~= h || partialW ~= w
    feaImg = ones(h, w) * fill_value;
    feaImg(top:bot, left:right) = partialImg;
    imwrite(feaImg, imgName);
else
    imwrite(partialImg, imgName);
end