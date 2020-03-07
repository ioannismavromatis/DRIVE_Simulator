function [losRSS,nLosRSS,rssAll] = ...
          calculateRSSV2I(losNlosStatus,distanceTiles,sortedIndexes,potentialBSPos,BS,ratName)
%CALCULATERSSV2I Calculate the RSS value for all the potential BS positions
% and the tiles found before. The RSS values are calculated for the LOS
% tiles, the NLOS tiles and the overall RSS for any given type of tile.
%
%  Input  :
%     losNlosStatus  : The classification of each tile (LOS/NLOS) for a
%                      given BS - 0 is NLOS, 1 is LOS
%     distanceTiles  : The distance of each tile from a given BS.
%     sortedIndexes  : The sorted indexes for the tile close to BS, given
%                      from the closest to the furthest one.
%     outputMap      : The map structure extracted from the map file or loaded
%                      from the preprocessed folder and updated until this point.
%     potentialBSPos : All the potential for the given RAT.
%     BS             : Structure containing all the informations about the
%                      basestations.
%     ratName        : The name of RAT that will be used in this function.
%
%  Output :
%     losRSS         : The received signal strength for the LOS tiles.
%     nLosRSS        : The received signal strength for the NLOS tiles.
%     rssAll         : The received signal strength for the all given tiles.
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
% email: ioannis.mavromatis@toshiba-bril.com

    tic
    % Find the received power at each tile found before - use a the
    % linkbudget lookup table for that
    for i = 1:length(sortedIndexes)
        % Find the LOS RSS values
        losTilesDistance = distanceTiles{i}(losNlosStatus{i});
        if max(losTilesDistance) > max(potentialBSPos.linkBudget(i).distanceLos)
            idxToNotConsider = find(losTilesDistance>=potentialBSPos.linkBudget(i).distanceLos(end),1);
            idxToNotConsider = idxToNotConsider - 1;
        else
            idxToNotConsider = length(losTilesDistance);
        end
        [~,losPos] = ismember(losTilesDistance(1:idxToNotConsider),potentialBSPos.linkBudget(i).distanceLos);
        RSSLos = potentialBSPos.linkBudget(i).signalReceivedLos(losPos);
        lengthRSSLos = length(RSSLos);
        lengthTiles = length(losTilesDistance);
        losRSS{i} = [ RSSLos repmat(-300,[1, lengthTiles - lengthRSSLos]) ];

        % Find the NOS RSS values
        nLosTilesDistance = distanceTiles{i}(~losNlosStatus{i});
        if ~isempty(nLosTilesDistance)
            if max(nLosTilesDistance) > max(potentialBSPos.linkBudget(i).distanceNLos)
                idxToNotConsider = find(nLosTilesDistance>=potentialBSPos.linkBudget(i).distanceNLos(end),1);
                idxToNotConsider = idxToNotConsider - 1;
            else
                idxToNotConsider = length(nLosTilesDistance);
            end
            nLosPos = [];
            if idxToNotConsider~=0 && ~isempty(potentialBSPos.linkBudget(i).distanceNLos)
                [~,nLosPos] = ismember(nLosTilesDistance(1:idxToNotConsider),potentialBSPos.linkBudget(i).distanceNLos);
            end
            RSSNLos = potentialBSPos.linkBudget(i).signalReceivedNLos(nLosPos);
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
        verbose('Finding the RSS values for all tiles and each potential macrocell BS position took %f seconds.', toc);
    else
        verbose('Finding the RSS values for all tiles and each potential femtocell BS position took %f seconds.', toc);
    end
end

