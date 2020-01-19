function outputMap = alignToXY(outputMap)
%alignToXY Align the map to the beginning of the axis.
%  This function is considered only in the case that an OSM map is loaded.
%  When a SUMO scenario is chosen, SUMO is responsible for correctly
%  aligning the map and the mobility traces.
%
%  Input  :
%     outputMap : The map structure extracted from the map file or loaded
%                 from the preprocessed folder
%
%  Output :
%     outputMap : The map structure with the aligned coordinates.
%
% Copyright (c) 2018-2019, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
    
    global SIMULATOR
    
    % Align the map when an OSM map is used
    if SIMULATOR.map == 0
        outputMap.areaVerticesY = outputMap.areaVerticesY - outputMap.bbox(1,1);
        outputMap.areaVerticesX = outputMap.areaVerticesX - outputMap.bbox(2,1);
        outputMap.tileVerticesY = outputMap.tileVerticesY - outputMap.bbox(1,1);
        outputMap.tileVerticesX = outputMap.tileVerticesX - outputMap.bbox(2,1);
        outputMap.inCentresTile(:,1) = outputMap.inCentresTile(:,1) - outputMap.bbox(2,1);
        outputMap.inCentresTile(:,2) = outputMap.inCentresTile(:,2) - outputMap.bbox(1,1);
        outputMap.inCentresArea(:,1) = outputMap.inCentresArea(:,1) - outputMap.bbox(2,1);
        outputMap.inCentresArea(:,2) = outputMap.inCentresArea(:,2) - outputMap.bbox(1,1);

        outputMap.buildings(:,3) = outputMap.buildings(:,3) - outputMap.bbox(2,1);
        outputMap.buildings(:,2) = outputMap.buildings(:,2) - outputMap.bbox(1,1);
        outputMap.buildingsIn(:,3) = outputMap.buildingsIn(:,3) - outputMap.bbox(2,1);
        outputMap.buildingsIn(:,2) = outputMap.buildingsIn(:,2) - outputMap.bbox(1,1);
        outputMap.buildingsAnimation(:,3) = outputMap.buildingsAnimation(:,3) - outputMap.bbox(2,1);
        outputMap.buildingsAnimation(:,2) = outputMap.buildingsAnimation(:,2) - outputMap.bbox(1,1);
        outputMap.foliage(:,3) = outputMap.foliage(:,3) - outputMap.bbox(2,1);
        outputMap.foliage(:,2) = outputMap.foliage(:,2) - outputMap.bbox(1,1); 
        outputMap.foliageAnimation(:,3) = outputMap.foliageAnimation(:,3) - outputMap.bbox(2,1);
        outputMap.foliageAnimation(:,2) = outputMap.foliageAnimation(:,2) - outputMap.bbox(1,1); 

        outputMap.roadsPolygons(:,3) = outputMap.roadsPolygons(:,3) - outputMap.bbox(2,1);
        outputMap.roadsPolygons(:,2) = outputMap.roadsPolygons(:,2) - outputMap.bbox(1,1);
        
        if isfield(outputMap,'vHandleTile')
            outputMap.vHandleTile(:,1) = outputMap.vHandleTile(:,1) - outputMap.bbox(2,1);
            outputMap.vHandleTile(:,2) = outputMap.vHandleTile(:,2) - outputMap.bbox(1,1);
        end
            
        
        % The new bounds for the map
        minX = min(min(outputMap.buildingsAnimation(:,2)),min(outputMap.foliageAnimation(:,2)));
        minY = min(min(outputMap.buildingsAnimation(:,3)),min(outputMap.foliageAnimation(:,3)));
        maxX = max(max(outputMap.buildingsAnimation(:,2)),max(outputMap.foliageAnimation(:,2)));
        maxY = max(max(outputMap.buildingsAnimation(:,3)),max(outputMap.foliageAnimation(:,3)));
        bounds = [ minX, maxX ; minY, maxY ];
        
        outputMap.bbox = bounds;
                       
        verbose('The map was aligned correctly with the beginning of the axis')
    end
end

