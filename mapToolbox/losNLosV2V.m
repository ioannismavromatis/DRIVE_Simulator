function [losIDs, nLosIDs, losNlosStatus, distanceTiles, sortedIndexes] = losNLosV2V(outputMap,BS,ratName)
%LOSNLOSV2V On a per tile-basis, find the surrounding tiles that are
%  in LOS or NLOS and the correlating RSS value. Return all the values to
%  the main program. This function works only for the femtocell RATs, as
%  this is considered the potential mobile-node - to - mobile-node
%  approach for this framework.
%
%  Input  :
%     outputMap      : The map structure extracted from the map file or loaded
%                      from the preprocessed folder and updated until this point.
%     BS             : Structure containing all the informations about the
%                      basestations.
%     ratName        : The name of RAT that will be used in this function.
%
%  Output :
%     losIDs         : Tile IDs that are in LOS between two tiles
%     nLosIDs        : Tile IDs that are in NLOS between two tiles
%     losNlosStatus  : The classification of each tile (LOS/NLOS) for a
%                      given BS - 0 is NLOS, 1 is LOS
%     distanceTiles  : The distance of each tile from a another given tile.
%     sortedIndexes  : The sorted indexes for the tile close to a ginen tile,
%                      sorted from the closest to the furthest one.
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
    
    global SIMULATOR
    tic
    
    % Use the max TX distance for both pdist2 functions as it is the longest
    % possible one.
    [ distanceTiles, sortedIndexes ] = pdist2(outputMap.inCentresTile(:,1:2), outputMap.inCentresTile(:,1:2),'euclidean','Radius',BS.(ratName).maxTXDistance);

    distanceTiles = cellfun(@(x)round(x,1),distanceTiles,'UniformOutput',false);

    [ ~, sortedIndicesBuildings] = pdist2([outputMap.buildings(:,3) outputMap.buildings(:,2)], outputMap.inCentresTile(:,1:2),'euclidean','Radius',BS.(ratName).maxTXDistance);

    % initiliase the cells to be returned later
    losIDs = cell(1,length(sortedIndexes));
    nLosIDs = cell(1,length(sortedIndexes));
    buildingIds = cell(1,length(sortedIndexes));

    % find the unique building polygons to compare the rays later
    for i = 1:length(sortedIndicesBuildings)
        buildingIds{i} = unique(outputMap.buildings(sortedIndicesBuildings{i},1));
    end

    N = length(sortedIndexes);
    WaitMessage = parfor_wait(N, 'Waitbar', true);
   
    parfor (i = 1:length(sortedIndexes),SIMULATOR.parallelWorkers)
        WaitMessage.Send;
        if ~isempty(sortedIndexes{i})
            % Find the the "rays" that should be tested with the buildings polygon
            % A ray is defined as the link between a BS and the incentre of a
            % map tile.
            raysToTest = [ repmat(outputMap.inCentresTile(i,1:2),[length(sortedIndexes{i}),1]), outputMap.inCentresTile(sortedIndexes{i},1:2) ];

            buildingsToTest = [];
            for k = 1:length(buildingIds{i})
                building = [ outputMap.buildings( ismember(outputMap.buildings(:,1), buildingIds{i}(k)), 3 ) ...
                    outputMap.buildings( ismember(outputMap.buildings(:,1), buildingIds{i}(k)), 2 ) ];
                buildingsToTest = [ buildingsToTest ;
                    building(1:end-1,1) ...
                    building(1:end-1,2) ...
                    building(2:end,1)   ...
                    building(2:end,2) ];
            end
            if ~isempty(buildingsToTest)
                % if any NaNs were parsed during the loading phase of SUMO or
                % while loading the OSM map, remove these buildings
                buildingsToTest(isnan(buildingsToTest(:,1)),:) = [];
                buildingsToTest(isnan(buildingsToTest(:,3)),:) = [];

                % calculate the LOS and NLOS status for the all links
                % for each given ray using the buildings found before
                [ losLinks,nLosLinks, losIDs{i}, nLosIDs{i},losNlosStatus{i} ] = ...
                    losNlosCalculation(sortedIndexes{i},raysToTest,buildingsToTest);

            else
                % when no buildings are available, all tiles are assumed to
                % be in LOS
                losIDs{i} = sortedIndexes{i};
                losNlosStatus{i} = true(1,length(losIDs{i}));
            end
        end
    end
    
    F = findall(0,'type','figure','tag','TMWWaitbar');
    delete(F)
    verbose('Finding all the LOS and NLOS links between all the pairs of tiles took: %f seconds.', toc); 
end

