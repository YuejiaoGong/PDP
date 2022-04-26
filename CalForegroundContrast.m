function [CtrC, CtrD, CtrT, CtrF, wCtrF]= CalForegroundContrast(colDistM, posDistM, texDistM, bgProb, SPdepth)

spaSigma = 0.4;     %sigma for spatial weight
depSigma = 0.4;     %sigma for depth 
posWeight = Dist2WeightMatrix(posDistM, spaSigma);

% color contrast
CtrC = colDistM .* posWeight;
CtrC = sum(CtrC,2);

CtrC = (CtrC - min(CtrC)) / (max(CtrC) - min(CtrC) + eps);
%CtrC = contrastEnhance(CtrC);

% depth contrast
CtrD = 1 - exp(-(SPdepth).^2 / (2 * depSigma * depSigma));
CtrD = (CtrD - min(CtrD)) / (max(CtrD) - min(CtrD) + eps);

% texture contrast
texSigma = 0.5 * mean(mean(texDistM));
texDistM = 1 - exp(-(texDistM).^2 / (2 * texSigma * texSigma));
CtrT = texDistM .* posWeight * bgProb;
CtrT = sum(CtrT,2);
CtrT = (CtrT - min(CtrT)) / (max(CtrT) - min(CtrT) + eps);

% fused contrast
CtrF = 3 ./ (1./CtrC + 1./CtrD + 1./CtrT);
CtrF = (CtrF - min(CtrF)) / (max(CtrF) - min(CtrF) + eps);

% adding bgProb
wCtrF = CtrF .* (1-bgProb + eps);
wCtrF = (wCtrF - min(wCtrF)) / (max(wCtrF) - min(wCtrF) + eps);
thresh = graythresh(wCtrF);  %automatic threshold
wCtrF(wCtrF < thresh) = 0;



