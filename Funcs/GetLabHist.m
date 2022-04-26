function histLab = GetLabHist(pixelList, image, spNum)

Lab_bins = [8, 8, 8];
nLabHist = prod(Lab_bins);
   
image_lab = RGB2Lab(image);

% Lab histogram
L = image_lab(:,:,1);
a = image_lab(:,:,2);
b = image_lab(:,:,3);
    
ll = min(floor(L/(1/Lab_bins(1))) + 1, Lab_bins(1));
aa = min(floor((a)/(1/Lab_bins(2))) + 1, Lab_bins(2));
bb = min(floor((b)/(1/Lab_bins(3))) + 1, Lab_bins(3));
Q_lab = (ll-1) * Lab_bins(2) * Lab_bins(3) + ...
   (aa-1) * Lab_bins(3) + ...
    bb + 1;
    
    
tmpLab = zeros(spNum, nLabHist);
histLab = zeros(spNum, nLabHist);

for n = 1 : spNum
    pixels = pixelList{n};
    tmpLab(n, :) = hist( Q_lab(pixels), 1:nLabHist )';
    histLab(n, :) = tmpLab(n, :) / max( sum(tmpLab(n, :)), eps );
end
    
    


