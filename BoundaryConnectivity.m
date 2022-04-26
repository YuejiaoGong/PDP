function [bdCon, Len_bnd, Area] = BoundaryConnectivity(adjcMatrix, colDistMatrix, bdIds)

[meanMin1, meanTop, meanMin2] = GetMeanMinAndMeanTop(adjcMatrix, colDistMatrix, 0.01);
clipVal = meanMin2;

% Emperically choose adaptive sigma for converting geodesic distance to weight
geoSigma = min([10, meanMin1 * 3, meanTop / 10]);
geoSigma = max(geoSigma, 2)/2;

adjcMatrix = LinkBoundarySPs(adjcMatrix, bdIds);
adjcMatrix = tril(adjcMatrix, -1);
edgeWeight = colDistMatrix(adjcMatrix > 0);
edgeWeight = max(0, edgeWeight - clipVal);

% Cal pair-wise shortest path cost (geodesic distance)
geoDistMatrix = graphallshortestpaths(sparse(adjcMatrix), 'directed', false, 'Weights', edgeWeight);
Wgeo = Dist2WeightMatrix(geoDistMatrix, geoSigma) ;

Len_bnd = sum( Wgeo(:, bdIds), 2); %length of perimeters on boundary
Area = sum(Wgeo, 2);    %soft area
bdCon = Len_bnd ./ sqrt(Area);