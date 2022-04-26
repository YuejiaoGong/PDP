function fusedCtr = SaliencyFusionViaOptimization(bgMap, fgMap, adjcMatrix, bdIds, colDistM, spNum)


bgEntropy = entropy(bgMap) + eps;
fgEntropy = entropy(fgMap) + eps;

adjcMatrix_nn = LinkNNAndBoundary(adjcMatrix, bdIds);
DistM = colDistM; 
neiSigma = 0.25 * mean(mean(DistM));
DistM(adjcMatrix_nn == 0) = Inf;
Wn = Dist2WeightMatrix(DistM, neiSigma);                    %smoothness term

mu = 0.1;                                                   %small coefficients for regularization term
W = Wn + adjcMatrix * mu;  
W =W *1;
%add regularization term
D = diag(sum(W));

bgWeight = 1 / bgEntropy;
fgWeight = 1 / fgEntropy;
E_bg = diag(bgMap * bgWeight);                              %background term
E_fg = diag(fgMap * fgWeight);                              %foreground term


fusedCtr =(2 * (D - W) + E_bg + E_fg) \ (E_fg * ones(spNum, 1) );
% fusedCtr = (fusedCtr - min(fusedCtr)) / (max(fusedCtr) - min(fusedCtr) + eps);

