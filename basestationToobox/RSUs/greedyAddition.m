function [chosenBSpos, tilesCovered, highestRSS ]  = greedyAddition(BS,potentialBSPos,losIDs,nLosIDs,rssAll,outputMap,sortedIndexes,losNlos,map,ratName)
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
    
    pos = potentialBSPos.(ratName).pos;
    
    toRemove = zeros(length(pos),1);
    for i = 1:length(toRemove)
        if pos(i,2)<outputMap.bbox(2,1)+300 ||...
           pos(i,2)>outputMap.bbox(2,2)-300 ||...
           pos(i,1)<outputMap.bbox(1,1)+300 ||...
           pos(i,1)>outputMap.bbox(1,2)-300
           toRemove(i) = 1;
        end
    end

    
    [ ~, maxIndex ] =  max(cellfun('length', losIDs{ratPos}));
    allTilesSystem=reshape(cell2mat(losIDs{ratPos}),[],1);
    allTilesSystem = unique(allTilesSystem);
    
    tilesToCover = ceil((1-BS.toleranceParam)*length(allTilesSystem));
    
   
    % Initialise the execution by taking the BS with the most LOS tiles.
    chosenBSpos = maxIndex;
    tilesCovered = tilesNumCovered(chosenBSpos,losIDs{ratPos},nLosIDs{ratPos});
   
    % Initialse an array with zeros.
    tiles = zeros(length(potentialBSPos.(ratName).pos),length(allTilesSystem));
    
    % When a tile is covered by a BS (either in LOS or NLOS), a logical 1 is added in the array.
    for i = 1:length(potentialBSPos.(ratName).pos)
        tmp = tilesNumCovered(i,losIDs{ratPos},nLosIDs{ratPos});
        tiles(i,tmp.allIDs)=1;
    end
    
    tmpLosNumber = tilesCovered.losNumber;
    discardedBSpos = find(~toRemove == 0)';
    
    
    % Operate until the expected number of covered tiles is reached.
    while tilesCovered.totalNumber < tilesToCover
        tiles([ chosenBSpos discardedBSpos ],:) = 0;
        if discardedBSpos(end)==1 && discardedBSpos(end-1) == 1
            fprintf("Maximum value will not achieved. The current result is returned.\n")
            break
        end
            
        sumAll = sum(tiles,2);
        [~,jj] =max(sumAll);
        chosenBSpos(length(chosenBSpos)+1) = jj;
        tilesCovered = tilesNumCovered(chosenBSpos,losIDs{ratPos},nLosIDs{ratPos});
        if tilesCovered.totalNumber<=tmpLosNumber
            discardedBSpos = [ discardedBSpos chosenBSpos(end) ];
            chosenBSpos = chosenBSpos(1:end-1);
            
        end
        tmpLosNumber = tilesCovered.totalNumber;
    end
    
    % Calculate the highest RSS value for the chosen BSs
    [ ~,highestRSS,highestRSSPlot,~,tileIDs,~ ]  = highestRSSValues(chosenBSpos,outputMap,sortedIndexes{ratPos}, rssAll{ratPos},losNlos{ratPos});    
    
%     For debug purposes
%     heatmapPrint(outputMap,map,highestRSSPlot,chosenBSpos,potentialBSPos.(ratName).pos,tileIDs)        
%     hold on
%     plot(pos(~toRemove,2), pos(~toRemove,1),...
%          '+','color',[0 1 0],'MarkerSize',15,'LineWidth',2)

    
    verbose('Finding the best RSUs using Greedy Addition took %f seconds.', toc);
end
