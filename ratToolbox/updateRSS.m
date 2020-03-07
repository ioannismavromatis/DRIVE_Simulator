function [losRSS,nLosRSS,rssAll,potentialPos] = updateRSS(losNlosStatus,distanceTiles,sortedIndexes,potentialPos,BS,ratName)
%UPDATERSS If the configuration of a number of basestations is changed
%  during the execution time, recalculate the RSS values given the already
%  known LOS and NLOS tiles. 
%
%  Input  :
%     losNlosStatus  : The classification of each tile (LOS/NLOS) for a
%                      given BS - 0 is NLOS, 1 is LOS
%     distanceTiles  : The distance of each tile from a given BS.
%     sortedIndexes  : The sorted indexes for the tile close to BS, given
%                      from the closest to the furthest one.
%     potentialPos   : The structure containing all the information about
%                      the potential positions for the BS and their characteristics.
%     BS             : Structure containing all the informations about the
%                      basestations.
%     ratName        : The name of RAT that will be used in this function.
%
%  Output :
%     losRSS         : The received signal strength for the LOS tiles.
%     nLosRSS        : The received signal strength for the NLOS tiles.
%     rssAll         : The received signal strength for the all given tiles.
%     potentialPos   : Updating the linkbudget for each potential BS in the
%                      system.
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
% email: ioannis.mavromatis@toshiba-bril.com

    tic
    
    for ii = 1:length(sortedIndexes)
        potentialPos.linkBudget(ii) = linkBudgetCalculation(potentialPos.configuration(ii));
    end
    
    % Find the received power at each tile found before - use a the
    % linkbudget lookup table for that
    for i = 1:length(sortedIndexes)
        % Find the LOS RSS values
        losTilesDistance = distanceTiles{i}(losNlosStatus{i});
        if max(losTilesDistance) > max(potentialPos.linkBudget(i).distanceLos)
            idxToNotConsider = find(losTilesDistance>=potentialPos.linkBudget(i).distanceLos(end),1);
            idxToNotConsider = idxToNotConsider - 1;
        else
            idxToNotConsider = length(losTilesDistance);
        end
        [~,losPos] = ismember(losTilesDistance(1:idxToNotConsider),potentialPos.linkBudget(i).distanceLos);
        RSSLos = potentialPos.linkBudget(i).signalReceivedLos(losPos);
        lengthRSSLos = length(RSSLos);
        lengthTiles = length(losTilesDistance);
        losRSS{i} = [ RSSLos repmat(-300,[1, lengthTiles - lengthRSSLos]) ];

        % Find the NOS RSS values
        nLosTilesDistance = distanceTiles{i}(~losNlosStatus{i});
        if ~isempty(nLosTilesDistance)
            if max(nLosTilesDistance) > max(potentialPos.linkBudget(i).distanceNLos)
                idxToNotConsider = find(nLosTilesDistance>=potentialPos.linkBudget(i).distanceNLos(end),1);
                idxToNotConsider = idxToNotConsider - 1;
            else
                idxToNotConsider = length(nLosTilesDistance);
            end
            nLosPos = [];
            if idxToNotConsider~=0
                [~,nLosPos] = ismember(nLosTilesDistance(1:idxToNotConsider),potentialPos.linkBudget(i).distanceNLos);
            end
            RSSNLos = potentialPos.linkBudget(i).signalReceivedNLos(nLosPos);
        else
            RSSNLos = [];
        end
        lengthNRSSLos = length(RSSNLos);
        lengthTiles = length(nLosTilesDistance);
        nLosRSS{i} = [ RSSNLos repmat(-300,[1, lengthTiles - lengthNRSSLos]) ];

        % Find the overall RSS values
        rssAll{i} = repmat(-300,[1,length(sortedIndexes{i})]);
        rssAll{i}(losNlosStatus{i}) = losRSS{i};
        rssAll{i}(~losNlosStatus{i}) = nLosRSS{i};
    end

    if strcmp(BS.(ratName).ratType,'macro')
        verbose('Finding the RSS values for all tiles and each potential macrocell basestation position took %f seconds.', toc);
    else
        verbose('Finding the RSS values for all tiles and each potential femtocell basestation position took %f seconds.', toc);
    end
end

