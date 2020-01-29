function [ potentialPos, mountedBuilding] = osmMacroPositions( outputMap, map )
%OSMMACROPOSITIONS Find the potential basestation positions for the macrocells
%  RSUs, when SUMO is being used. All the RSUs are placed in a grid-like
%  approach using the density given by the user. Also, the potential
%  position of the basestations is aligned with the centre of the closest
%  building -- to ensure that is always on top of a building.
%
%  Input  :
%     outputMap       : The map structure extracted from the map file or 
%                       loaded from the preprocessed folder and updated
%                       until this point.
%     map             : Structure containing all map settings (filename,  
%                       path, simplification tolerance to be used, etc).
%
%  Output :
%     potentialPos    : All the potential positions generated from this 
%                       function.
%     mountedBuilding : The ID of the building that each BS is mounted to.
%
% Copyright (c) 2018-2019, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk

    warning('off','MATLAB:delaunayTriangulation:DupPtsWarnId');
    
    tic
    % Take the half of the density setting and setup the initial x and y values
    limit = map.macroDensity*1000/2;

    x = min(outputMap.buildings(:,3))+limit:map.macroDensity*1000:max(outputMap.buildings(:,3));
    y = min(outputMap.buildings(:,2))+limit:map.macroDensity*1000:max(outputMap.buildings(:,2));
    
    % Generate the grid with the potential basestation positions
    [X,Y] = meshgrid(x,y);
    bsPosX = reshape(X,[numel(X) 1]);
    bsPosY = reshape(Y,[numel(Y) 1]);

    % Re-align the centre and the vertices coordinates to be centred on the
    % map. This helps to avoid the border effect the edges of the map
    xMin = abs(min(outputMap.buildings(:,3)) - min(bsPosX));
    yMin = abs(min(outputMap.buildings(:,2)) - min(bsPosY));
    xMax = abs(max(outputMap.buildings(:,3)) - max(bsPosX));
    yMax = abs(max(outputMap.buildings(:,2)) - max(bsPosY));

    potentialPosInitial = [ bsPosX + (xMax - xMin)/2   bsPosY + (yMax - yMin)/2 ];
    potentialPosInitial = [ potentialPosInitial(:,2) potentialPosInitial(:,1) ];

    % Find the closest building to the existing basestation positions
    [ ~, cornerID ] = pdist2([outputMap.buildings(:,3),outputMap.buildings(:,2)],[potentialPosInitial(:,2),potentialPosInitial(:,1)],'euclidean','SMALLEST',1);
    
    % Using delaunay triangulation, take the incentre of the polygon and
    % make that as the new basestation position. By that, the macrocell
    % basestation is placed at the centre of the building. The basestation
    % is placed at the top of the building.
    for i = 1:length(cornerID)
        buildingID = outputMap.buildings(cornerID(i),1);
        potentialPos(i,:) = outputMap.buildingIncentre(outputMap.buildingIncentre(:,1)==buildingID,2:4);
        mountedBuilding(i) = buildingID;
    end
    
    % For debug purposes only
%     clf
%     mapPrint(outputMap)
%     alpha(0.2)
%     hold on
%     plot(potentialPosInitial(:,2),potentialPosInitial(:,1),'o','MarkerSize',10)
%     hold on
%     plot(potentialPos(:,2),potentialPos(:,1),'o','MarkerSize',10)
    
    verbose('Calculating the potential macrocell basestation positions took: %f seconds.', toc);
end

