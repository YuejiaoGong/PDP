function outImg = RemoveSmallRegion(Img)

%[m n] = size(Img);
% level = graythresh(Img);
% BW = im2bw(Img,level);
% imshow(BW);
% 
% stats = regionprops(BW);
% Ar = cat(1, stats.Area);
% ind = find(Ar ==max(Ar));%找到最大连通区域的标号
% BW(find(BW~=ind))=0;%将其他区域置为0
% figure,imshow(BW);%显示最大联通区域

level = graythresh(Img);
image_bw = im2bw(Img,level);
%imshow(image_bw);

L = bwlabel(image_bw);%标记连通区域
stats = regionprops(L);
Ar = cat(1, stats.Area);
ind = find(Ar == max(Ar));%找到最大连通区域的标号
thresh = Ar(ind) / 5;
removeInd = find (Ar < thresh);
outImg = Img;
if ~isempty(removeInd)
    for n = 1:length(removeInd)
        outImg(find(L == removeInd(n)))=0;%将其他区域置为0
    end
end

% imshow(Img)
% %outImg = Img .* image_bw;
% figure,imshow(outImg);%显示最大联通区域

%normalize
% minVal = min(min(outImg));
% maxVal = max(max(outImg));
% outImg = (outImg - minVal) ./ (maxVal - minVal + eps);


