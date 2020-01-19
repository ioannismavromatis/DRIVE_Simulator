function runMain( map, sumo, BS, linkBudget )
%runMain The main function of the simulator - it is responsible for all the
%  functionalities of the framework.
%
%  Input  :
%     map        : Structure containing all map settings (filename, path,
%                  simplification tolerance to be used, etc).
%     sumo       : Structure containing all the SUMO settings (maximum
%                  number of vehicles, start time, end time, etc.)
%     BS         : Structure to be filled with the basestation information
%     linkBudget : Structure to be filled with the link budget information
%
% Copyright (c) 2018-2019, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk

    global SIMULATOR
    
    startTraci(sumo)
    
    [ BS, linkBudget, map ] = loadRATs(BS,linkBudget,map);    
    outputMap = loadMap(map,sumo);
    
    if isempty(outputMap)
        fprintf('No network file was loaded! Something went wrong...\n')
        error('Check the network file given by the user');
    end
    
    outputMap = mapSmallerAreas(outputMap,map);
    outputMap = mapTiles(outputMap,map);
    outputMap = alignToXY(outputMap);
    outputMap = buildingCentres(outputMap);
    
    % Assume that node-to-node communication will only take place using the
    % femtocell communication plane
    [ losIDsPerTile, nLosIDsPerTile,losNlosStatusPerTile, distancePerTile, sortedIndicesPerTile, ...
        initialLosV2VRSS, initialNLosV2VRSS, initialRssAllV2V] = ...
             perTileLosNLosCaching(outputMap,BS,linkBudget,map,'mmWaves');
    
    potentialBSPos = potentialBSPositions(outputMap, BS, map,linkBudget);
    
    [ losIDsPerRAT,nLosIDsPerRAT, losNlosStatusPerRAT, distancePerRAT, ...
        sortedIndexesPerRat, initialLosTilesRSS, initialNLosTilesRSS, initialRssAll, ...
        distanceBuildings, sortedIndexesBuildings, rssBuildings ] = ...
                perRATTiles(outputMap,potentialBSPos,BS,map);

    if strcmp(SIMULATOR.scenario,'osm')
        % Return empty arrays if the OSM functionality is chosen -- The
        % vehicular and pedestrian mobilities will not be parsed.
        vehicles = [];
        pedestrians = [];
        
        runOSM(map,BS,outputMap,potentialBSPos,distancePerRAT,sortedIndexesPerRat,losNlosStatusPerRAT,initialRssAll);
    elseif strcmp(SIMULATOR.scenario,'sumo')
        [ vehicles, pedestrians ] = runSUMO(sumo,map,BS,outputMap,potentialBSPos,distancePerRAT,sortedIndexesPerRat,losNlosStatusPerRAT,initialRssAll, distanceBuildings, sortedIndexesBuildings, rssBuildings);
    elseif strcmp(SIMULATOR.scenario,'v2v')
        [ vehicles, pedestrians ] = runV2V(sumo,map,BS,outputMap,distancePerTile,sortedIndicesPerTile,losNlosStatusPerTile,initialRssAllV2V);
    else
        fprintf('Wrong scenario name. Please check the chosen scenario in simSettings.m file.\n')
        error('Wrong chosen scenario.');
    end
    
    [ vehiclesStruct, pedestriansStruct ] = parseMobility(sumo, vehicles, pedestrians);
    
    printAnimate(sumo,vehiclesStruct,pedestriansStruct,outputMap)
    traci.close();
end

