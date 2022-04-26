function adjcMatrix = LinkNNAndBoundary(adjcMatrix, bdIds)
%link 2 layers of neighbor super-pixels and boundary patches

% Code Author: Wangjiang Zhu
% Email: wangjiang88119@gmail.com
% Date: 3/24/2014
tmp = adjcMatrix * adjcMatrix + adjcMatrix;
adjcMatrix = (adjcMatrix * adjcMatrix + adjcMatrix) > 0;
adjcMatrix = double(adjcMatrix);

adjcMatrix(bdIds, bdIds) = 1;