function outputMap = smallerAreasHexagons(outputMap,tile,largeTiles)
%smallerAreasHexagons This function takes as an input the given map size
% from the user and breaks the main map into smaller subareas. Also, the
% buildings that are within the new smaller maps are calculated in order to
% speed up the execution of the simulator later.
%
% If the user gives zero as an input the map is not changed.
%
% This function generates hexagonal-shaped areas on the map. See
% smallerAreasHexagons for the squared-shaped areas.
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
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
% email: ioannis.mavromatis@toshiba-trel.com

    global VERBOSELEVEL SIMULATOR
    tic
    
    % Ignore this function if user gives 0 in the settings
    if tile==0
        maxX = max(outputMap.buildings(:,3));
        minX = min(outputMap.buildings(:,3));
        maxY = max(outputMap.buildings(:,2));
        minY = min(outputMap.buildings(:,2));
        outputMap.mapToRunX = [ minX maxX maxX minX minX ];
        outputMap.mapToRunY = [ minY minY maxY maxY minY ];
        outputMap.buildingsIn = outputMap.buildings;
        return;
    end

    % Calculate the different centres of the hexagons using Voronoi diagrams
    bounds = [ min(outputMap.buildings(:,3)) min(outputMap.buildings(:,2))...
               max(outputMap.buildings(:,3)) max(outputMap.buildings(:,2)) ];
    [X, Y] = meshgrid(bounds(1):tile:bounds(3),bounds(2):tile:bounds(4));
    [ n1, n2 ] = size(X);
    tmpArray = repmat([0 tile/2],[n1,ceil(n2/2)]);
    Y = Y + tmpArray(1:n1,1:n2);
    [V,C] = voronoin([X(:) Y(:)]) ;
    
    for i = 1:length(C)
        ll(i) = length(C{i});
    end
    
    xc = cellfun(@(x) mean(V(x,1)),C(ll>5));
    yc = cellfun(@(x) mean(V(x,2)),C(ll>5));
    inCentres = [xc yc];
    inCentres(inCentres(:,1)==inf,:) = [];
    
    % re-align the centre and the vertices coordinates to be centred on the
    % map. This helps to avoid the border effect the edges of the map 
    xMin = abs(bounds(1) - min(inCentres(:,1)));
    yMin = abs(bounds(2) - min(inCentres(:,2)));
    xMax = abs(bounds(3) - max(inCentres(:,1)));
    yMax = abs(bounds(4) - max(inCentres(:,2)));
    
    inCentres = [ inCentres(:,1) + (xMax - xMin)/2   inCentres(:,2) + (yMax - yMin)/2 ];
    V = [ V(:,1) + (xMax - xMin)/2   V(:,2) + (yMax - yMin)/2 ];
    
    pHandle = C(ll>5);
    % find the vertices of all the hexagons
    parfor (i = 1:length(pHandle),SIMULATOR.parallelWorkers)
        idx = pHandle{i};
        idx = [ idx idx(1) ];
        tmp = V(idx,:);
        tileVerticesX(i,:) = V(idx,1);
        tileVerticesY(i,:) = V(idx,2);
    end
    
    
    if nargin>2
    % put in the outputMap structure all the calculated information
        outputMap.vHandleArea = V;
        outputMap.pHandleArea = pHandle;
        outputMap.inCentresArea = [ inCentres zeros(length(inCentres),1) ];
        outputMap.areaVerticesX = tileVerticesX;
        outputMap.areaVerticesY = tileVerticesY;
    else
        outputMap.vHandleTile = V;
        outputMap.pHandleTile = pHandle;
        outputMap.inCentresTile = [ inCentres zeros(length(inCentres),1) ];
        outputMap.tileVerticesX = tileVerticesX;
        outputMap.tileVerticesY = tileVerticesY;
    end
    
    
    % Execute this section if map area tiles are to be calculated
    if nargin > 2
        % Find the buildings that are withing the new smaller areas
        [toRun,~] = size(tileVerticesX);
        for i = 1 : toRun
            tmp=inpolygon(outputMap.buildings(:,3),outputMap.buildings(:,2),tileVerticesX(i,:),tileVerticesY(i,:));
            buildingIDs = outputMap.buildings(tmp,1);
            uniqueIDs = unique(buildingIDs,'stable');
            allBuildings = ismember(outputMap.buildings(:,1),uniqueIDs);
            buildingsIn(:,i) = allBuildings;
        end
        tmp = sum(buildingsIn,2)>=1;
        outputMap.buildingsIn = outputMap.buildings(tmp,:);
    end
    
    %% For debug purposes only - plot the old map, the new sub-maps and the buildings within the new polygons
    if VERBOSELEVEL >= 2
        if nargin > 2
            testMapPlot(outputMap,'area')
        else
            testMapPlot(outputMap,'tile')
        end
        fprintf('Press enter in the command line to continue!\n')
        pause
    end
    
    
    
    if nargin > 2
        verbose('Calculating the Hexagonal Areas took: %f seconds', toc)
    else
        verbose('Calculating the Hexagonal Tiles took: %f seconds', toc)
    end
end

