function newPolygon = testPolygonPlot(polygon)
%testBuildingPlot Function that is used to convert the building and park
%  polygons to structure that is easier haldled. This structure is used
%  from the functions related with the plotting within the software.
%
%  Input  :
%     polygon : The polygon to be manipulated.
%
%  Output :
%     newPolygon : The polygon that can be plotted (after manipulation).
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
% email: ioannis.mavromatis@toshiba-bril.com

    changeIndexes = diff(polygon(:,1))~=0;
    changeIndexes = [ 0 ; changeIndexes ];
    changeIdxBuildings = find(changeIndexes == 1);
    matrix = [0:length(changeIdxBuildings)-1]';
    changeIdxBuildings = changeIdxBuildings+matrix;
    [r,c]       = size(polygon);
    add         = numel(changeIdxBuildings);            % How much longer Anew is
    newPolygon = NaN(r + add,c);        % Preallocate
    idx         = setdiff(1:r+add,changeIdxBuildings);  % all positions of Anew except pos
    newPolygon(idx,:) = polygon;
end

