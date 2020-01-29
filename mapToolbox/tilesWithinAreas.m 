function outputMap = tilesWithinAreas(outputMap)
%tilesWithinAreas For the given building polygons, calculate which tiles
%  are outside of them. Also, calculate which tiles lay within each map
%  area calculated before (either hexagonal or squared). Some of them may 
%  not belong to any area.
%
%  Input  :
%     outputMap : The map structure extracted from the map file or loaded
%                 from the preprocessed folder
%
%  Output :
%     outputMap : The map structure with the added information regarding
%                 the tiles withing the given areas.
%
% Copyright (c) 2018-2019, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk

    % Find the incentres that are outside of the building polygons
    inIdx = inpoly2(outputMap.inCentresTile(:,1:2), [ outputMap.nodes(:,3) outputMap.nodes(:,2) ], outputMap.edges);
    inIdx = logical(~inIdx);
    
    % Get the new values for all the above
    outputMap.inCentresTile = outputMap.inCentresTile(inIdx,:);
    outputMap.tileVerticesX = outputMap.tileVerticesX(inIdx,:);
    outputMap.tileVerticesY = outputMap.tileVerticesY(inIdx,:);
    
    % Find the incentres within the map areas
    outputMap.inCentresTileArea = zeros(length(outputMap.inCentresTile),1);
    [ l,~ ] = size(outputMap.areaVerticesX);
    for i = 1:l
        in = inpoly2(outputMap.inCentresTile(:,1:2), [outputMap.areaVerticesX(i,:)' outputMap.areaVerticesY(i,:)']);
        outputMap.inCentresTileArea(in) = i;
    end
    
    %% For debug purposes only - plot the old map, the new sub-maps and the buildings within the new polygons
    if false
        testMapPlot(outputMap,'tile')
    end
end

