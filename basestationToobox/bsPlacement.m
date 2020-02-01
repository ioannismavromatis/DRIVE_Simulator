function [ chosenRSUpos, tilesCovered,tilesCoveredIDs,highestRSS ] = bsPlacement(BS,potentialBSPos,losIDsPerRAT,initialLosTilesRSS,outputMap,ratName);
%BSPLACEMENT This function executed the chosen algorithm for the BS
%   placement, chosen by the end user. The three algorithms provided are
%   just examples of the simulator's functionality. Other algorithms can be
%   added to further extend SMARTER's capabilities.
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
    
    if strcmp(SIMULATOR.bsPlacement,'ga')
        [ chosenRSUpos,tilesCovered,tilesCoveredIDs,highestRSS ] =...
            gaSolver(BS,potentialBSPos,losIDsPerRAT,initialLosTilesRSS,outputMap,ratName);
    elseif strcmp(SIMULATOR.bsPlacement,'greedy')
        [ chosenRSUpos,tilesCovered,tilesCoveredIDs,highestRSS ] =...
            greedyAddition(BS,potentialBSPos,losIDsPerRAT,initialLosTilesRSS,outputMap,ratName);
    elseif strcmp(SIMULATOR.bsPlacement,'random')   
        [ chosenRSUpos,tilesCovered,tilesCoveredIDs,highestRSS ] =...
            randomChosen(BS,potentialBSPos,losIDsPerRAT,initialLosTilesRSS,outputMap,ratName);
    else
        disp('Wrong Basestation Placement algorithm was given. Please provide a correct name!')
        error('Wrong Basestation Placement algorithm.');
    end
end

