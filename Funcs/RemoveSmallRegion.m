function outImg = RemoveSmallRegion(Img)

%[m n] = size(Img);
% level = graythresh(Img);
% BW = im2bw(Img,level);
% imshow(BW);
% 
% stats = regionprops(BW);
% Ar = cat(1, stats.Area);
% ind = find(Ar ==max(Ar));%�ҵ������ͨ����ı��
% BW(find(BW~=ind))=0;%������������Ϊ0
% figure,imshow(BW);%��ʾ�����ͨ����

level = graythresh(Img);
image_bw = im2bw(Img,level);
%imshow(image_bw);

L = bwlabel(image_bw);%�����ͨ����
stats = regionprops(L);
Ar = cat(1, stats.Area);
ind = find(Ar == max(Ar));%�ҵ������ͨ����ı��
thresh = Ar(ind) / 5;
removeInd = find (Ar < thresh);
outImg = Img;
if ~isempty(removeInd)
    for n = 1:length(removeInd)
        outImg(find(L == removeInd(n)))=0;%������������Ϊ0
    end
end

% imshow(Img)
% %outImg = Img .* image_bw;
% figure,imshow(outImg);%��ʾ�����ͨ����

%normalize
% minVal = min(min(outImg));
% maxVal = max(max(outImg));
% outImg = (outImg - minVal) ./ (maxVal - minVal + eps);


