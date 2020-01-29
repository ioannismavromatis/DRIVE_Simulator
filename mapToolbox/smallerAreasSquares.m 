function output = smallerAreasSquares(output,tile,largeTiles)
%smallerAreasSquares This function takes as an input the given map size
% from the user and breaks the main map into smaller subareas. Also, the
% buildings that are within the new smaller maps are calculated in order to
% speed up the execution of the simulator later.
%
% If the user gives zero as an input the map is not changed.
%
% This function generates squared-shaped areas on the map. See
% smallerAreasHexagons for the hexagonal-shaped areas.
%
%  Input  :
%     outputMap  : The map structure extracted from the map file or loaded
%                  from the preprocessed folder.
%     tile       : The size of the tile chosen (in meters).
%     largeTiles : If a third argument is given, then the larger area tiles
%                  will be calculated for the map. Having just two
%                  arguments, represents the smaller map tiles.
%
%  outputMap :
%     outputMap  : The map structure with the added information regarding
%                  the area tiles (either hexagonal or squared).
%
% Copyright (c) 2018-2019, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk

    global VERBOSELEVEL SIMULATOR
    tic
    
    x = max(output.buildings(:,3)) - min(output.buildings(:,3));
    y = max(output.buildings(:,2)) - min(output.buildings(:,2));

    % Ignore this function if user gives 0 in the settings
    if tile==0
        maxX = max(output.buildings(:,3));
        minX = min(output.buildings(:,3));
        maxY = max(output.buildings(:,2));
        minY = min(output.buildings(:,2));
        output.tileVerticesX = [ minX maxX maxX minX minX ];
        output.tileVerticesY = [ minY minY maxY maxY minY ];
        output.buildingsIn = output.buildings;
        return;
    end

    % Calculate the centre of the map and the number of submaps that should
    % be generated.
    xCentre = (max(output.buildings(:,3)) + min(output.buildings(:,3)))/2;
    yCentre = (max(output.buildings(:,2)) + min(output.buildings(:,2)))/2;
    
    timesX = ceil(x/tile);
    timesY = ceil(y/tile);
    
    % Find the different x and y coordinates 
    if mod(timesX,2)
        times = 0:floor(timesX/2);
        xValuesGreater = xCentre + times(2:end)*tile;
        xValuesLower = xCentre - times(2:end)*tile;
        xValues = sort([ xValuesLower xCentre xValuesGreater ]);
    else
        times = 0:floor(timesX/2)-1;
        xValuesGreater = xCentre + times*tile + tile/2;
        xValuesLower = xCentre - times*tile - tile/2;
        xValues = sort([ xValuesLower xValuesGreater ]);
    end
 
    if mod(timesY,2)
        times = 0:floor(timesY/2);
        yValuesGreater = yCentre + times(2:end)*tile;
        yValuesLower = yCentre - times(2:end)*tile;
        yValues = sort([ yValuesLower yCentre yValuesGreater ]);
    else
        times = 0:floor(timesY/2)-1;
        yValuesGreater = yCentre + times*tile + tile/2;
        yValuesLower = yCentre - times*tile - tile/2;
        yValues = sort([ yValuesLower yValuesGreater ]);        
    end
      
    % Find the coordinates that form the new squared polygon maps
    tileVerticesX = [];
    tileVerticesY = [];
    parfor (i = 1:length(xValues)-1,SIMULATOR.parallelWorkers)
        for k = 1:length(yValues)-1      
            tileVerticesXtmp = [ xValues(i) xValues(i+1) xValues(i+1) xValues(i) xValues(i) ];
            tileVerticesYtmp = [ yValues(k) yValues(k) yValues(k+1) yValues(k+1) yValues(k) ];
            tileVerticesX = [ tileVerticesX ; tileVerticesXtmp ];
            tileVerticesY = [ tileVerticesY ; tileVerticesYtmp ];
        end
    end

    % find the midpoints of all the tiles - this is the incentre of each tile
    inCentres = [ (tileVerticesX(:,1) + tileVerticesX(:,3))/2 (tileVerticesY(:,1) + tileVerticesY(:,3))/2 ];
    
    % All dimensions are in 3d. The tiles on the map are considered to be
    % at 0m elevation
    if nargin > 2
        output.areaVerticesX = tileVerticesX;
        output.areaVerticesY = tileVerticesY;
        output.inCentresArea = [ inCentres zeros(length(inCentres),1) ];
    else
        output.tileVerticesX = tileVerticesX;
        output.tileVerticesY = tileVerticesY;
        output.inCentresTile = [ inCentres zeros(length(inCentres),1) ];
    end
    
    % Execute this section if map area tiles are to be calculated
    [toRun,~] = size(tileVerticesX);
    if nargin > 2        
        % Find the buildings that are withing the new smaller maps
        for i = 1 : toRun
            tmp=inpolygon(output.buildings(:,3),output.buildings(:,2),tileVerticesX(i,:),tileVerticesY(i,:));
            buildingIDs = output.buildings(tmp,1);
            uniqueIDs = unique(buildingIDs,'stable');
            allBuildings = ismember(output.buildings(:,1),uniqueIDs);
            buildingsIn(:,i) = allBuildings;
        end
        tmp = sum(buildingsIn,2)>=1;
        output.buildingsIn = output.buildings(tmp,:);
    end
    
    %% For debug purposes only - plot the old map, the new sub-maps and the buildings within the new polygons
    if VERBOSELEVEL >= 2
        if nargin > 2
            testMapPlot(output,'area')
        else
            testMapPlot(output,'tile')
        end
        fprintf('Press enter in the command line to continue!\n')
        pause
    end
    
    if nargin > 2
        verbose('Calculating the Squared Areas took: %f seconds', toc)
    else
        verbose('Calculating the Squared Tiles took: %f seconds', toc)
    end
end

