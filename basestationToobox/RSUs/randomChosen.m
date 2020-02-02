function [chosenBSPos, tilesCovered, highestRSS ] = randomChosen(BS,potentialBSPos,losIDs,nLosIDs,rssAll,outputMap,sortedIndexes,losNlos,ratName)
%randomChosen This function chooses a random number of basestations, based
%   on the number given by the user. This function can be used for
%   debugging purposes as it generates the fastest results between the
%   provided BS placement algorithms. 
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
%     chosenBSPos     : The IDs of the chosen BSs.
%     tilesCovered    : The tiles covered by the selected BSs.
%     highestRSS      : The highest RSS for the chosen BSs (per tile). 
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk

    global SIMULATOR
    
    tic
    
    ratPos = find(strcmp(ratName,BS.rats)==1);
    
    noOfRSUsToDeploy = SIMULATOR.randomToChoose;
    [ noOfBSs, ~ ] = size(potentialBSPos.(ratName).pos);
    if noOfRSUsToDeploy > noOfBSs
        noOfRSUsToDeploy = noOfBSs;
    end
    
    % Sample the potential BS positions and get a number of basestations to
    % deploy.
    chosenBSPos = randsample(noOfBSs,noOfRSUsToDeploy);
        
    % Calculate the number of covered tiles in the system
    tilesCovered = tilesNumCovered(chosenBSPos,losIDs{ratPos},nLosIDs{ratPos});
    
    % Find the highest RSS per tile
    [ ~,highestRSS,~,~,~,~ ]  = highestRSSValues(chosenBSPos,outputMap,sortedIndexes{ratPos}, rssAll{ratPos},losNlos{ratPos});
    
    verbose('The Random Basestation Selection took %f seconds.', toc);
end
