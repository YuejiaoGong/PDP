function nCtr = contrastEnhance(Ctr, sharpness)

tou = graythresh(Ctr);
nCtr = 1 ./ (1 + exp( -sharpness * (Ctr - tou)));