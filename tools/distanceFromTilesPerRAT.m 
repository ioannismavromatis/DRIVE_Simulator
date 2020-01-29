function [ distanceTiles, sortedIdxTile, distanceBuildings, sortedIdxBuildings, buildingIds ] = ...
                  distanceFromTilesPerRAT(outputMap, potentialPos,BS,ratName)
%DISTANCEFROMTILESPERRAT Calculates the distance from each potential BS 
%  position and the tile incentres. Also, calculates the distance from all 
%  of the buildings from the tile incentres as well. For both distances, a
%  the corners radius is taken into account. That radius is the maximum
%  distance thatthe signal is still deliverable for a given link (as it
%  was calculatedduring the link budget analysis).
%
%  Input  :
%     outputMap         : The map structure extracted from the map file or loaded
%                         from the preprocessed folder and updated until this point.
%     potentialPos      : All the potential positions generated from this
%                         function for all the different RATs.
%     BS                : Structure containing all the informations about the
%                         basestations.
%     ratName           : The name of RAT that will be used in this function.
%
%  Output :
%     distanceTiles     : The distance of each tile from a given BS.
%     sortedIdxTile     : The sorted indexes for the tiles close to BS, given
%                         from the closest to the furthest one.
%     distanceBuildings : The distance of each tile from a given building.
%     sortedIdxBuildings: The sorted indexes for the tiles close to 
%                         buildings, given from the closest to the furthest one.
%     buildingIds       : The unique IDs of the sorted buildings.
%
% Copyright (c) 2018-2019, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk

    tic
    
    % Calculate the distances and the indexes of each tile 
    [ distanceTiles, sortedIdxTile] = pdist2(outputMap.inCentresTile, [ potentialPos(:,2) potentialPos(:,1) potentialPos(:,3) ],'euclidean','Radius',BS.(ratName).maxTXDistance);
       
    [ distanceBuildings, sortedIdxBuildings] = pdist2([outputMap.buildings(:,3) outputMap.buildings(:,2)], [ potentialPos(:,2) potentialPos(:,1) ],'euclidean','Radius',BS.(ratName).maxTXDistance);
    
    % Round all values to one decimal point for femtocells or to an
    % integer value for macrocells - this will help with the lookup table later
    if strcmp(BS.(ratName).ratType,'femto')
        distanceTiles = cellfun(@(x)round(x,1),distanceTiles,'UniformOutput',false);
        distanceBuildings = cellfun(@(x)round(x,1),distanceBuildings,'UniformOutput',false);
    else
        distanceTiles = cellfun(@(x)round(x,0),distanceTiles,'UniformOutput',false);
        distanceBuildings = cellfun(@(x)round(x,0),distanceBuildings,'UniformOutput',false);
    end
    
    for i = 1:length(sortedIdxBuildings)
        buildingIds{i} = unique(outputMap.buildings(sortedIdxBuildings{i},1));
    end
    
    % for debug purposes only
    if false
        k = 10;
        if ~isempty(buildingIds{k})
            clf
            for i = 1:length(buildingIds{k})
                xBuildings = outputMap.buildings( ismember(outputMap.buildings(:,1), buildingIds{k}(i)), 3 );
                yBuildings = outputMap.buildings( ismember(outputMap.buildings(:,1) ,buildingIds{k}(i)), 2 );
                patch(xBuildings,yBuildings,'red')
                hold on
            end
            plot(potentialPos(k,2),potentialPos(k,1),'bo')
        else
            verbose('Empty. Try again')
        end
    end
    
    if strcmp(BS.(ratName).ratType,'macro')
        verbose(['Finding the distance of each tile incentre from the ' ...
                    'potential macrocell BS positions took %f seconds.'], toc);
    else
        verbose(['Finding the distance of each tile incentre from the ' ...
            'potential femtocell BS positions took %f seconds.'], toc);
    end
end

