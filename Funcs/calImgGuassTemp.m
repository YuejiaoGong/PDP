function template = calImgGuassTemp(refImage)
%% Calculate the object-biased Gaussian model.

[r c] = size(refImage);
template = zeros(r,c);

%% Calculate the object center.
row = 1:r;
row = row';
col = 1:c;
XX = repmat(row,1,c).*refImage;
YY = repmat(col,r,1).*refImage;
xcenter = sum(XX(:))/sum(refImage(:));
ycenter = sum(YY(:))/sum(refImage(:));

%% Calculate the Gaussian model.
sigmaRatio = 0.25;
sigma=[r*sigmaRatio c*sigmaRatio];
for xx = 1:r
    for yy = 1:c
        template(xx,yy) = exp(-(xx-xcenter)^2/(2*sigma(1)^2)-(yy-ycenter)^2/(2*sigma(2)^2));
    end
end