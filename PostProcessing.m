function FsalMap = PostProcessing(smap)

%[r c] = size(smap);
FsalMap = RemoveSmallRegion(smap);

template = calImgGuassTemp(smap);
GauFsalMap  = FsalMap .* template;

nlayer = 5;
for n = 1: nlayer
    coef = 1 / n;
    thresh = coef * graythresh(FsalMap);
    tempMap = FsalMap;
    tempMap(FsalMap < thresh) = 0;
    FsalMap = FsalMap + coef * tempMap;
end

FsalMap = FsalMap + GauFsalMap;

%normalize
minVal = min(min(FsalMap));
maxVal = max(max(FsalMap));
FsalMap = (FsalMap - minVal) ./ (maxVal - minVal + eps);
