function [chosenRSUpos, tilesCovered, tilesCoveredIDs, highestRSS ]  = greedyAdditionChosenRSUpositions(potRSUPositions,losTileIDs,RSU,rssTile,tileWithinEdgeIDs,simulator)
%GREEDYADDITIONCHOSENRSUPOSITIONS Summary of this function goes here
%   Detailed explanation goes here
    
    tic
    
	[ ~, maxIndex ] =  max(cellfun('length', losTileIDs));
    allTilesSystem=reshape(cell2mat(losTileIDs),[],1);
    allTilesSystem = unique(allTilesSystem);
    tilesToCover = ceil((1-RSU.toleranceParam)*length(allTilesSystem));
   
    cRSUpos(1,:) = [ potRSUPositions(maxIndex,:) maxIndex ];
    [ tilesCovered, tilesCoveredIDs ] = tilesNumCovered(cRSUpos(:,3),losTileIDs);
   
    while tilesCovered<tilesToCover
        tilesCoveredTmp = [];
        posToTest = logical(1:length(potRSUPositions));
        posToTest(cRSUpos(:,3))=false;
        tmp = cRSUpos(:,3);
        ttt = find(posToTest==1);
        for i = 1:length(ttt)
            tmp(length(cRSUpos(:,3))+1) = ttt(i);
            [ tilesCoveredTmp(i), ~ ] = tilesNumCovered(tmp,losTileIDs);
        end
        [dd, maxIdx] = max(tilesCoveredTmp);
        [ row, ~ ] = size(cRSUpos);
        cRSUpos(row+1,:) = [ potRSUPositions(ttt(maxIdx),:) ttt(maxIdx) ];
        
        [ tilesCovered, tilesCoveredIDs ] = tilesNumCovered(cRSUpos(:,3),losTileIDs);
        [ ~, ~,highRSS ] = highestRSSValues(cRSUpos(:,3),losTileIDs, rssTile, tileWithinEdgeIDs);
        meanRSS = mean(highRSS);
    end    
    
    if ~isempty(losTileIDs{maxIndex})
        chosenRSUpos = cRSUpos(:,3);
    else
        chosenRSUpos = cRSUpos(1:end-1,3);
    end
    
    [ ~, ~,highestRSS ] = highestRSSValues(cRSUpos(:,3),losTileIDs, rssTile, tileWithinEdgeIDs);
    
    if simulator.verboseLevel >= 1
        fprintf('Finding the best RSUs using Greedy Addition took %f seconds.\n', toc);
    end
end
