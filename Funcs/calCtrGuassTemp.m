function template = calCtrGuassTemp(ctr,meanPos)
%% Calculate the object-biased Gaussian model.

spNum = length(ctr);
template = zeros(spNum, 1);

%% Calculate the object center.
XX = ctr .* meanPos(:,1);
YY = ctr .* meanPos(:,2);
sumctr = sum(ctr);
xcenter = sum(XX) / sumctr;
ycenter = sum(YY) / sumctr;

%% Calculate the Gaussian model.
sigmaRatio = 0.25;
sigmax = sigmaRatio * max(meanPos(:,1));
sigmay = sigmaRatio * max(meanPos(:,2));
for n = 1 : spNum
    template(n) = exp(...
    -(meanPos(n,1)-xcenter)^2/(2*sigmax^2)...
    -(meanPos(n,2)-ycenter)^2/(2*sigmay^2)...
    );
end


