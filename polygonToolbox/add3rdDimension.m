function buildings = add3rdDimension(buildings)
%ADD3RDDIMENSION Add a 3rd dimension in the buildings polygon
%   All the buildings are given a random height between 15m and 50m.
%
%  Input  :
%     buildings : The buildings that should be manipulated.
%
%  Output :
%     outputMap : The buildings polygon represented in 3D.
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk

    % randomly give a height for each building
    [ ~, idx ] = unique(buildings(:,1),'rows','stable');
    uniqueBuildingHeights = rand(length(idx),1)*35 + 15;

    % and replicate that height for all the points that form the building polygon
    buildingHeights = [];
    for i = 2:length(idx)
        buildingHeights = [ buildingHeights ; repmat(uniqueBuildingHeights(i-1), [ idx(i) - idx(i-1) ], 1) ];
    end

    buildingHeights = [ buildingHeights ; repmat(uniqueBuildingHeights(i), [ length(buildings) - idx(i) + 1 ], 1) ];
    buildings = [ buildings buildingHeights ];
end

