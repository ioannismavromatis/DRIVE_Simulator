function [vehicles,pedestrians] = ...
            runSUMO(sumo,map,BS,outputMap,distanceTiles,sortedIndexes,losNlosStatus,rssAll)
%RUNV2V This is the main function for the V2V scenario. 
%
%  Input  :
%     sumo          : Structure containing all the SUMO settings (maximum
%                     number of vehicles, start time, end time, etc.)
%     map           : Structure containing all map settings (filename, path,
%                     simplification tolerance to be used, etc).
%     outputMap     : The map structure containing all the map information.
%     distanceTiles : The distanceTiles of each tile from another given tile.
%     sortedIndexes : The sorted indexes for the nearby tiles, given
%                     from the closest to the furthest one.
%     losNlosStatus : The classification of each tile (LOS/NLOS) for a
%                     given BS - 0 is NLOS, 1 is LOS
%     rssAll        : The received signal strength for the all given tiles.
%
%  Output :
%     vehicles      : Array containing all the information about the
%                     vehicles for the entire simulation time.
%     pedestrians   : Array containing all the information about the
%                     pedestrians for the entire simulation time.
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
% email: ioannis.mavromatis@toshiba-trel.com

    tic 
    
    % Progress to the first simulation step
    traci.simulationStep;
    timeStep = traci.simulation.getTime;

    % Create the vehicle and pedestrian arrays
    vehicles = [];
    pedestrians = [];
    v2vLinks = zeros(1,1000);
    p2pLinks = zeros(1,1000);
    finalV2Vlinks = 0;
    finalP2Plinks = 0;
    
    % Start iterating for all the timesteps
    for i = 1:sumo.endTime
        vehicleIDs = traci.vehicle.getIDList();
        pedestrianIDs = traci.person.getIDList();
        timeStep = traci.simulation.getTime;
        fprintf('The timestep is: %f\n',timeStep)
        
        [ vehicleTimestep, pedestrianTimestep ] = getVehiclesAndPedestrians(sumo,vehicleIDs,pedestrianIDs,timeStep);
        vehicles = [ vehicles ; vehicleTimestep ];
        pedestrians = [ pedestrians ; pedestrianTimestep ];
        
        [distanceVehicleTile,idxVehicleTile,distancePedestrianTile,idxPedestrianTile] = ...
            nearbyTile(outputMap,vehicleTimestep,pedestrianTimestep);
        
        [tmp,~] = size(vehicleTimestep);
        
        if tmp>1
            [ distanceVehicle, idxVehicle ] = pdist2(vehicleTimestep(:,2:3), vehicleTimestep(:,2:3), 'euclidean', 'Smallest', 2);
            distanceVehicle = distanceVehicle(2:end,:);
            idxVehicle = idxVehicle(2:end,:);
            idx = distanceVehicle<=BS.mmWaves.maxTXDistance;
            v2vLinks(vehicleTimestep(idx,1)'+1) = v2vLinks(vehicleTimestep(idx,1)'+1) + 1;
        end
        
        [tmp,~] = size(pedestrianTimestep);
        if tmp>1
            [ distancePedestrian, idxPedestrian ] = pdist2(pedestrianTimestep(:,2:3), pedestrianTimestep(:,2:3), 'euclidean', 'Smallest', 2);
            distancePedestrian = distancePedestrian(2:end,:);
            idxPedestrian = idxPedestrian(2:end,:);
            idx = distancePedestrian<=BS.mmWaves.maxTXDistance;
            p2pLinks(pedestrianTimestep(idx,1)'+1) = p2pLinks(pedestrianTimestep(idx,1)'+1) + 1;
        end
        
        % Progress to the timestep
        traci.simulationStep;
        
    end
    
    if ~isempty(vehicles)
        finalV2Vlinks = v2vLinks(unique(vehicles(:,1))+1);
    end
    if ~isempty(pedestrians)
        finalP2Plinks = p2pLinks(unique(pedestrians(:,1))+1);
    end
    
    fprintf('On average each vehicle established a communication for %d seconds, and each pedestrian for %d seconds.\n',round(mean(finalV2Vlinks)),round(mean(finalP2Plinks)));
    verbose('The entire V2V mode took: %f seconds.', toc); 
end

