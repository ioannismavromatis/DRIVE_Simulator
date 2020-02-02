function [ chosenRSUpos, tilesCovered,tilesCoveredIDs,highestRSS ] = gaSolver(BS,potentialBSPos,losIDsPerRAT,initialLosTilesRSS,outputMap,ratName)
%gaSolver This function solves the best-placement problem for the potential
%  RSUs using a genetic algorithm.
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
    
    for seed = 1:SIMULATOR.gaSeed
        tic
        [ chosenRSUposTmp{seed}, tilesCoveredTmp{seed},tilesCoveredIDsTmp{seed},highestRSSTmp{seed} ] = gaSolverMap(BS, potentialBSPos.(ratName).pos, losIDsPerRAT{2}, initialLosTilesRSS{2}, outputMap, seed);
        verbose('The Genetic Algorithm solver took %f seconds.', toc);
    end
    [~,yy] = min(cellfun('length',chosenRSUposTmp));
    chosenRSUpos = chosenRSUposTmp{yy}';
    tilesCovered = tilesCoveredTmp{yy}';
    tilesCoveredIDs = tilesCoveredIDsTmp{yy}';
    highestRSS = highestRSSTmp{yy};
end

function [ chosenRSUpos, tilesCovered,tilesCoveredIDs,highestRSS ] = gaSolverMap(BS, potRSUPos, losTileIDs, rssTile,outputMap, seed)

    global VERBOSELEVEL
    BS.rssThreshold = -90;
    
    %   1. lower and upper bounds for variable e_i:
    [noVars,~] = size(potRSUPos);
    lb = zeros( noVars, 1 ) ;
    ub = ones( noVars, 1 ) ;
    
    %   2. NonlinearConstr defines the nonlinear constraints of the problem.
    [N,~] = size(outputMap.inCentresTile);
    nlConst = @(e)nlConstFun(e, N, 1-(BS.toleranceParam), losTileIDs, BS.rssThreshold, rssTile);
    
    %   3. Linear constraints
    A = [];
    b = [];
    if VERBOSELEVEL>0
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
    
    chosenRSUpos = find(x==1);
    [ tilesCovered,tilesCoveredIDs ] = tilesNumCovered(chosenRSUpos,losTileIDs);
    highestRSS = highestRSSBSPlacement(chosenRSUpos,losTileIDs,rssTile);

end

function [c, ceq] = nlConstFun(e, N, t, losTileIDs, RSS_TH, rssTile)
    ceq = [];

    gammaF = tilesNumCovered(find(e==1),losTileIDs);
    c_1 = -(gammaF - t*N);
    
    highestRSS = highestRSSBSPlacement(find(e==1),losTileIDs,rssTile);
  
    tmp_1 = sort(highestRSS,'descend');

    c_2 = -(mean(tmp_1) - RSS_TH);
    
    c = [c_1; c_2];
    c = [c_1];
end

function out = objFun(e)
    out = sum(e);
end
