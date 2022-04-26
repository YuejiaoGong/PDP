function distM = GetX2DistanceMatrix(feature)

spNum = size(feature, 1);
distM = zeros(spNum, spNum);
%distM2 = zeros(spNum, spNum);
for i = 1 : spNum
    for j = (i+1) : spNum
        hist1 = feature(i,:); hist2 = feature(j,:);
        distM(i,j) = sum( (hist1 - hist2).^2 ./ (hist1 + hist2 + eps) );
        distM(j,i) = distM(i,j);
        %hist1 = wldO(i,:); hist2 = wldO(j,:);
        %distM2(i,j) = sum( (hist1 - hist2).^2 ./ (hist1 + hist2 + eps) );
        %distM2(j,i) = distM2(i,j);
    end
end

%texDistM = distM1 ;

