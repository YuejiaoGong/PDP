function salImg = ReconstructImage(feaVec, pixelList, h, w, frameRecord, doNormalize, fill_value)
% Fill back super-pixel values to image pixels 
%没有改完，是乱的

Img = CreateImageFromSPs(feaVec, pixelList, h, partialW, doNormalize);


if (nargin < 6)
    doNormalize = true;
end

if (nargin < 7)
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
partialImg = CreateImageFromSPs(feaVec, pixelList, partialH, partialW, doNormalize);

if partialH ~= h || partialW ~= w
    feaImg = ones(h, w) * fill_value;
    feaImg(top:bot, left:right) = partialImg;
    salImg = feaImg;
else
    salImg = partialImg;
end

