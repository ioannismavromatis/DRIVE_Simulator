function [ losIDs, nLosIDs, losNlosStatus, distanceTiles, sortedIndexes ] =...
              losNLosTilesPerRAT(outputMap,potentialBSPos,BS,ratName)
%LOSNLOSTILESPERRAT Find the LOS and NLOS tiles for the given RAT. 
%  Calculate the RSS per basestation for these tiles using the existing 
%  pathloss models given before.
%
%  Input  :
%     outputMap      : The map structure extracted from the map file or loaded
%                      from the preprocessed folder and updated until this point.
%     potentialBSPos : All the potential positions generated from this
%                      function for all the different RATs.
%     BS             : Structure containing all the informations about the
%                      basestations.
%     ratName        : The name of RAT that will be used in this function.
%
%  Output :
%     losIDs         : Tile IDs that are in LOS with each BS.
%     nLosIDs        : Tile IDs that are in NLOS with each BS.
%     losNlosStatus  : The classification of each tile (LOS/NLOS) for a
%                      given BS - 0 is NLOS, 1 is LOS
%     distanceTiles  : The distance of each tile from a given BS.
%     sortedIndexes  : The sorted indexes for the tile close to BS, given
%                      from the closest to the furthest one.
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
% email: ioannis.mavromatis@toshiba-trel.com
    
    global SIMULATOR
    tic
    parallelise = 0;
    % consider just this first X number of tiles for the LOS rays. All the
    % rest are consideres as NLOS -- speed up processing time
    refinementValueDefault = 20000;
    
    pos = potentialBSPos.(ratName).pos;
    
    [ distanceTiles, sortedIndexes, ~, ~, buildingIds ] =...
        distanceFromTilesPerRAT(outputMap,pos,BS,ratName);

    losIDs = cell(1,length(sortedIndexes));
    nLosIDs = cell(1,length(sortedIndexes));
    
    % remove the building that the basestation is mounted for
    % simplification - for the macrocell only
    if strcmp(BS.(ratName).ratType,'macro')
        for i = 1:length(sortedIndexes)        
            buildingIds{i}(buildingIds{i}==potentialBSPos.(ratName).mountedBuildings(i)) = [];
        end
    end
    
    % Parallelise the next for-loop for femtocells and use serial execution
    % for the macrocells - if a parallel loop is used for the macrocells,
    % an excessive amount of memory is required.
    if strcmp(BS.(ratName).ratType,'femto')
        parallelise = SIMULATOR.parallelWorkers;
    end
    
    N = length(sortedIndexes);
    WaitMessage = parfor_wait(N, 'Waitbar', true);
    
    parfor (i = 1:length(sortedIndexes),parallelise) 
        if ~isempty(sortedIndexes{i})
            refine = 1;
            refinementValue = refinementValueDefault;
            % Find the the "rays" that should be tested with the buildings polygon
            % A ray is defined as the link between a BS and the incentre of a
            % map tile.
            raysToTest = [ repmat([pos(i,2),pos(i,1)],[length(sortedIndexes{i}),1]), outputMap.inCentresTile(sortedIndexes{i},1:2) ];
            
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
            
            % Skip this iteration because all tiles are in LOS with the
            % potential BS position
            if isempty(buildingsToTest)
                losIDs{i} = sortedIndexes{i};
                continue
            end
            
            % if any NaNs were parsed during the loading phase of SUMO or
            % while loading the OSM map, remove these buildings
            buildingsToTest(isnan(buildingsToTest(:,1)),:) = [];
            buildingsToTest(isnan(buildingsToTest(:,3)),:) = [];

            if strcmp(BS.(ratName).ratType,'macro')
                if length(raysToTest)<refinementValue
                    refinementValue = length(raysToTest);
                    refine = 0;
                end
                
                % calculate the LOS and NLOS status for the macrocell links
                % for each given ray using the buildings found before
                [ losLinks, nLosLinks, losIDs{i}, nLosIDs{i}, losNlosStatus{i} ] = ...
                    losNlosCalculation(sortedIndexes{i},raysToTest(1:refinementValue,:),buildingsToTest);

                % if a refinement value is given, to minimise the
                % computational complexity, update the NLOS links
                if refine
                    [ nLosLinks, nLosIDs{i}, losNlosStatus{i} ] = ...
                        refinedNlosCalculation(nLosLinks,raysToTest,sortedIndexes{i},refinementValue);
                end
            else
                % calculate the LOS and NLOS status for the femtocell links
                % for each given ray using the buildings found before
                [ losLinks, nLosLinks, losIDs{i}, nLosIDs{i}, losNlosStatus{i} ] = ...
                    losNlosCalculation(sortedIndexes{i},raysToTest,buildingsToTest);
            end
        end
        
        WaitMessage.Send;
        
    end
    
    F = findall(0,'type','figure','tag','TMWWaitbar');
    delete(F)
    
    if strcmp(BS.(ratName).ratType,'macro')
        verbose('Finding the LOS tiles for each potential macrocell BS position took %f seconds.', toc);
    else
        verbose('Finding the LOS tiles for each potential femtocell BS position took %f seconds.', toc);
    end
end

    

