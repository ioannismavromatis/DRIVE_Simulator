function [ chosenBSPos, tilesCovered, highestRSS ] = gaSolver(BS,potentialBSPos,losIDs,nLosIDs,rssAll,outputMap,sortedIndexes,losNlos,ratName)
%gaSolver This function solves the best-placement problem for the potential
%  RSUs using a genetic algorithm.
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
% email: ioannis.mavromatis@toshiba-trel.com

    global SIMULATOR 
    
    ratPos = find(strcmp(ratName,BS.rats)==1);
    
    for mySeed = 1:SIMULATOR.gaSeed
        tic
        disp(['Running Genetic Algorithm with seed: ' num2str(mySeed) '/' num2str(SIMULATOR.gaSeed)])
        [ chosenRSUposTmp{mySeed}, tilesCoveredTmp{mySeed},highestRSSTmp{mySeed} ] = gaSolverMap(BS, potentialBSPos.(ratName).pos, losIDs{ratPos}, nLosIDs{ratPos}, rssAll{ratPos}, outputMap, sortedIndexes{ratPos}, losNlos{ratPos}, mySeed);
        verbose('The Genetic Algorithm solver took %f seconds.', toc);
    end
    
    
    [~,yy] = min(cellfun('length',chosenRSUposTmp));
    chosenBSPos = chosenRSUposTmp{yy}';
    tilesCovered = tilesCoveredTmp{yy}';
    highestRSS = highestRSSTmp{yy};
end

function [ chosenBSPos, tilesCovered,highestRSS ] = gaSolverMap(BS, potRSUPos, losTileIDs, nLosTileIDs, rssTile,outputMap,sortedIndexes,losNlos,seed)

    global VERBOSELEVEL
    BS.rssThreshold = -90;
    
    %   1. lower and upper bounds for variable e_i:
    [noVars,~] = size(potRSUPos);
    lb = zeros( noVars, 1 ) ;
    ub = ones( noVars, 1 ) ;
    
    %   2. NonlinearConstr defines the nonlinear constraints of the problem.
    [N,~] = size(outputMap.inCentresTile);
    nlConst = @(e)nlConstFun(e, N, 1-(BS.toleranceParam), losTileIDs,nLosTileIDs, BS.rssThreshold, rssTile,sortedIndexes,losNlos,outputMap);
    
    %   3. Linear constraints
    A = [];
    b = [];
    if VERBOSELEVEL>1
        str = 'diagnose';
    else
        str = 'off';
    end
    %   4. the GA solver is executed.
    options = optimoptions('ga',...
        'TolFun', 10^-10, ...
        'TolCon', 10^-10, ...
        'Generations',2000,...
        'UseParallel',true,...
        'Display',str ...
        );
    
    localObj = @(e)objFun(e);
    rng(seed,'twister')
    intVarsIdx = 1:noVars;
    [x, ~, ~] = ga( localObj, noVars, A, b, [], [], lb, ub, nlConst, intVarsIdx,options);
    
    chosenBSPos = find(x==1);
    tilesCovered = tilesNumCovered(chosenBSPos,losTileIDs,nLosTileIDs);
    [ ~,highestRSS,~,~,~,~ ]  = highestRSSValues(chosenBSPos,outputMap,sortedIndexes, rssTile,losNlos);

end

function [c, ceq] = nlConstFun(e, N, t, losTileIDs,nLosTileIDs, RSS_TH, rssTile,sortedIndexes,losNlos,outputMap)
    ceq = [];

    tmp = tilesNumCovered(find(e==1),losTileIDs,nLosTileIDs);
    gammaF = tmp.losNumber;
    c_1 = -(gammaF - t*N);
    
    chosenBSPos = find(e==1);
    [ ~,highestRSS,~,~,~,~ ]  = highestRSSValues(chosenBSPos,outputMap,sortedIndexes,rssTile,losNlos);
  
    tmp_1 = sort(highestRSS,'descend');

    c_2 = -(mean(tmp_1) - RSS_TH);
    
    c = [c_1; c_2];
    c = [c_1];
end

function out = objFun(e)
    out = sum(e);
end
