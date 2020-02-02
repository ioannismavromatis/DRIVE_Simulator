function [chosenRSUpos, tilesCovered, tilesCoveredIDs, highestRSS ]  = greedyAddition(BS,potentialBSPos,losIDsPerRAT,initialLosTilesRSS,outputMap,ratName)
%greedyAddition A greedy addition algorithm to choose the best BS positions
%  on the map. The BS that provides the better coverage (most tiles in LOS
%  is chosen every time), until the required number of tiles is reached.
%
%  Input  :
%     BS           : Structure to be filled with the basestation information
%     potentialPos : All the potential positions generated from this
%                      function for all the different RATs.
%     losIDsPerRAT : Tile IDs that are in LOS with each BS.
%     initialLosTilesRSS : The received signal strength for the LOS tiles.
%     outputMap    : The map structure extracted from the map file or loaded
%                    from the preprocessed folder and updated until this point.
%     ratName      : The name of RAT that will be used in this function.
%
%  Output :
%     chosenRSUpos    : The IDs of the chosen BSs.
%     tilesCovered    : The tiles covered by the selected BSs.
%     tilesCoveredIDs : The tile IDs that are covered.
%     highestRSS      : The highest RSS for the chosen BSs (per tile). 
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk    

    tic
    ratPos = find(strcmp(ratName,BS.rats)==1);
    
	[ ~, maxIndex ] =  max(cellfun('length', losIDsPerRAT{ratPos}));
    allTilesSystem=reshape(cell2mat(losIDsPerRAT{ratPos}),[],1);
    allTilesSystem = unique(allTilesSystem);
    tilesToCover = ceil((1-BS.toleranceParam)*length(allTilesSystem));
   
    chosenRSUpos(1) = maxIndex;
    [ tilesCovered, tilesCoveredIDs ] = tilesNumCovered(chosenRSUpos,losIDsPerRAT{ratPos});
   
    while tilesCovered<tilesToCover
        tilesCoveredTmp = [];
        posToTest = logical(1:length(potentialBSPos.(ratName).pos));
        posToTest(chosenRSUpos)=false;
        
        for i = 1:length(posToTest)
            if posToTest(i)
                [ tilesCoveredTmp(i), ~ ] = tilesNumCovered([chosenRSUpos i],losIDsPerRAT{ratPos});
            end
        end
        
        [~, maxIdx] = max(tilesCoveredTmp);
        chosenRSUpos(length(chosenRSUpos)+1) = maxIdx;
        
        [ tilesCovered, tilesCoveredIDs ] = tilesNumCovered(chosenRSUpos,losIDsPerRAT{ratPos});
        highestRSS = highestRSSBSPlacement(chosenRSUpos,losIDsPerRAT{ratPos}, initialLosTilesRSS{ratPos});
    end    
    
    verbose('Finding the best RSUs using Greedy Addition took %f seconds.', toc);
end
