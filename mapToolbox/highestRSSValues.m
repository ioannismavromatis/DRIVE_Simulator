function [ bsID, highRSSValue,rssValuetoPlot, losNlos, uniqueIDs, tilesNum ] = highestRSSValues(chosenBSpos,outputMap,sortedIndexes, rssAll,losNlosStatus)
%HIGHESTRSSVALUES Calculate the highest received signal strength for the
%  entire map, given a number of chosen basestations. It also finds the ID
%  of each basestation that serves a specific tile and if that particular
%  tile is in LOS or NLOS with the above mentioned basestation. Finally,
%  the RSS, the tile IDs, the service basestations and the total number of
%  covered tiles is returned to main function.
%
%  Input  :
%     chosenBSpos    : The chosen BS positions to be deployed on the map.
%     outputMap      : The map structure extracted from the map and
%                      modified afterwards.
%     sortedIndexes  : The sorted indexes for the tile close to BS, given
%                      from the closest to the furthest one.
%     rssAll         : The received signal strength for the all given tiles.
%     losNlosStatus  : The classification of each tile (LOS/NLOS) for a
%                      given BS - 0 is NLOS, 1 is LOS
%
%  Output :
%     bsID           : The map structure with the building incentres.
%     highRSSValue   : The highest RSS values for all the map tiles (-300
%                      implies that no signal is received).
%     rssValuetoPlot : A sanitized version of highRSSValue, for easier plotting.
%     losNlos        : The classification of all tile (LOS/NLOS) taking
%                      into account all deployed BSs
%     uniqueIDs      : The tile IDs that are served by a BS.
%     tilesNum       : The number of tiles served by a BS.
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
    
    tic
    
    % Initialise the RSS and the index matrices given the number of tiles
    % and basestations
    rss = ones(length(sortedIndexes),length(outputMap.inCentresTile)).*-300;
    idxArray = rss./300;


    % given the Basestation IDs, find all the corresponding RSS and indexes
    % and put them in the above matrices
    for i = 1:length(sortedIndexes(chosenBSpos))
        rss(i,sortedIndexes{chosenBSpos(i)}) = rssAll{chosenBSpos(i)};
        try
            idxArray(i,sortedIndexes{chosenBSpos(i)}) = losNlosStatus{chosenBSpos(i)};
        catch
            idxArray(i,sortedIndexes{chosenBSpos(i)}) = zeros(1,length(sortedIndexes{chosenBSpos(i)}));
        end
    end

    % find the maximum RSS and IDs
    [ highRSSValue, bsID ] = max(rss,[],1);
    [~,dummy] = size(idxArray);
    i = 1:dummy;
    losNlos = idxArray(sub2ind(size(idxArray),bsID,i));

    uniqueIDs = find(highRSSValue~=-300);
    uniqueIDsNot = highRSSValue==-300;
    rssValuetoPlot = highRSSValue(uniqueIDs);
    bsID(uniqueIDsNot) = -1;
    tilesNum = length(uniqueIDs);
    
end

