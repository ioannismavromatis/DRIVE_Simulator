function [chosenRSUpos, tilesCovered, tilesCoveredIDs, highestRSS ] = randomChosenRSUpositions(outputMap,potRSUPositions,RSU,chosenRSU,losTileIDs,rssTile,tileWithinEdgeIDs,simulator)
%RANDOMCHOSENRSUPOSITIONS Summary of this function goes here
%   Detailed explanation goes here

    tic
    % Surface of coverage. Given from the circle surface equation x = pi*r^2
    rangeSurface = pi*RSU.distanceThreshold^2; 
    % Calculate the number of RSUs to be deployed based on the total map size
    yHalfCircles = ceil(outputMap.ySize/(2*RSU.distanceThreshold));
    xHalfCircles = ceil(outputMap.xSize/(2*RSU.distanceThreshold));
    
    tangledHalfCircles = 2*yHalfCircles + 2*xHalfCircles;
    
    surfaceHalfCircles = (tangledHalfCircles*pi*RSU.distanceThreshold^2)/2;
    
    remainingSurface = outputMap.totalMapSize - surfaceHalfCircles;
    numberOfRSUsToDeploy = floor(remainingSurface/rangeSurface) + tangledHalfCircles/2;

%     chosenRSUpos = randi([1,length(potRSUPositions)], numberOfRSUsToDeploy,1);
    
    % Use the length of the Optimisation Algorithm
    chosenRSUpos = randi([1,length(potRSUPositions)], length(chosenRSU),1);
    
    % Calculate the number of covered tiles in the system
    [ tilesCovered, tilesCoveredIDs ] = tilesNumCovered(chosenRSUpos,losTileIDs);
    
    [ ~,~,highestRSS ] = highestRSSValues(chosenRSUpos,losTileIDs, rssTile, tileWithinEdgeIDs);
    
    if simulator.verboseLevel >= 1
        fprintf('Finding the best RSUs using Random Placement took %f seconds.\n', toc);
    end
end
