function [chosenBSpos, tilesCovered, highestRSS ]  = greedyAddition(BS,potentialBSPos,losIDs,nLosIDs,rssAll,outputMap,sortedIndexes,losNlos,ratName)
%greedyAddition A greedy addition algorithm to choose the best BS positions
%  on the map. The BS that provides the better coverage (most tiles in LOS
%  is chosen every time), until the required number of tiles is reached.
%
%  Input  :
%     BS           : Structure to be filled with the basestation information
%     potentialPos : All the potential positions generated from this
%                      function for all the different RATs.
%     losIDs       : Tile IDs that are in LOS with each BS.
%     nLosIDs      : Tile IDs that are in NLOS with each BS.
%     rssAll       : The received signal strength for the LOS tiles.
%     outputMap    : The map structure extracted from the map file or loaded
%                    from the preprocessed folder and updated until this point.
%     ratName      : The name of RAT that will be used in this function.
%
%  Output :
%     chosenBSpos     : The IDs of the chosen BSs.
%     tilesCovered    : The tiles covered by the selected BSs.
%     highestRSS      : The highest RSS for the chosen BSs (per tile). 
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk    
% email: ioannis.mavromatis@toshiba-trel.com    

    tic
    ratPos = find(strcmp(ratName,BS.rats)==1);
    
	[ ~, maxIndex ] =  max(cellfun('length', losIDs{ratPos}));
    allTilesSystem=reshape(cell2mat(losIDs{ratPos}),[],1);
    allTilesSystem = unique(allTilesSystem);
    tilesToCover = ceil((1-BS.toleranceParam)*length(allTilesSystem));
   
    chosenBSpos(1) = maxIndex;
    tilesCovered = tilesNumCovered(chosenBSpos,losIDs{ratPos},nLosIDs{ratPos});
   
    while tilesCovered.losNumber<tilesToCover
        tilesCoveredTmp = [];
        posToTest = logical(1:length(potentialBSPos.(ratName).pos));
        posToTest(chosenBSpos)=false;
        
        for i = 1:length(posToTest)
            if posToTest(i)
                tmpStruct = tilesNumCovered([chosenBSpos i],losIDs{ratPos},nLosIDs{ratPos});
                tilesCoveredTmp(i) = tmpStruct.totalNumber;
            end
        end
        
        [~, maxIdx] = max(tilesCoveredTmp);
        chosenBSpos(length(chosenBSpos)+1) = maxIdx;
        
        tilesCovered = tilesNumCovered(chosenBSpos,losIDs{ratPos},nLosIDs{ratPos});
        [ ~,highestRSS,~,~,~,~ ]  = highestRSSValues(chosenBSpos,outputMap,sortedIndexes{ratPos}, rssAll{ratPos},losNlos{ratPos});
    end    
    
    verbose('Finding the best RSUs using Greedy Addition took %f seconds.', toc);
end
