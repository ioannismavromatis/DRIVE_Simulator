% function [chosenRSUpos, tilesCovered, tilesCoveredIDs, highestRSS ] = randomChosen(outputMap,potRSUPositions,RSU,chosenRSU,losTileIDs,rssTile,tileWithinEdgeIDs,simulator)
function [chosenRSUpos, tilesCovered, tilesCoveredIDs, highestRSS ] = randomChosen(BS,potentialBSPos,losIDsPerRAT,initialLosTilesRSS,outputMap,ratName)
%randomChosen This function chooses a random number of basestations, based
%   on the number given by the user. This function can be used for
%   debugging purposes as it generates the fastest results between the
%   provided BS placement algorithms. 
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

    global SIMULATOR
    
    tic
    
    noOfRSUsToDeploy = SIMULATOR.randomToChoose;
    [ noOfBSs, ~ ] = size(potentialBSPos.(ratName).pos);
    if noOfRSUsToDeploy > noOfBSs
        noOfRSUsToDeploy = noOfBSs;
    end
    
    % Sample the potential BS positions and get a number of basestations to
    % deploy.
    chosenRSUpos = randsample(noOfBSs,noOfRSUsToDeploy);
        
    % Calculate the number of covered tiles in the system
    [ tilesCovered, tilesCoveredIDs ] = tilesNumCovered(chosenRSUpos,losIDsPerRAT{2});
    
    % Find the highest RSS per tile
    highestRSS = highestRSSBSPlacement(chosenRSUpos,losIDsPerRAT{2}, initialLosTilesRSS{2});
    
    verbose('The Random Basestation Selection took %f seconds.', toc);
end
