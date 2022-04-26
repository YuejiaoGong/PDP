function histLM = GetLMFeatures(pixelList, image, spNum)

filtext = makeLMfilters;
ntext = size(filtext, 3);
[h, w, ~] = size(image);
% texture - response of filter bank
grayim = rgb2gray( image );
imtext = zeros([h w ntext]);

for f = 1:ntext
   response = abs(imfilter(im2single(grayim), filtext(:, :, f), 'same'));    
   response = (response - min(response(:))) / (max(response(:)) - min(response(:)) + eps);
   imtext(:, :, f) = response;
end
[dummy, texthist] = max(imtext, [], 3);

nbins = 6;
tmpLM = zeros(spNum, nbins);
histLM = zeros(spNum, nbins);
for n = 1 : spNum
    pixels = pixelList{n};
    tmpLM(n, :) = hist( texthist(pixels), 1:nbins )';
    histLM(n, :) = tmpLM(n, :) / max( sum(tmpLM(n, :)), eps );
end    




