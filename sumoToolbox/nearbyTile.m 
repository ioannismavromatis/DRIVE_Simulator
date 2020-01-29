function [distanceVehicle,idxVehicle,distancePedestrian,idxPedestrian] = nearbyTile(outputMap,vehicleTimestep,pedestrianTimestep)
%NEARBYTILE Find the closest tile incentre for all vehicles and pedestrians
%  around the city. This is later considered as the point for all the
%  following calculations throughout the simulation time.
%
%  Input  :
%     outputMap       : The map structure containing all the map information.
%     vehicles        : Array containing all the information about the
%                       vehicles for the given timestep
%     pedestrians     : Array containing all the information about the
%                       pedestrians for the given timestep.
%
%  Output :
%     distanceVehicle : The distance of each vehicle from the tile incentres.
%     idxVehicle      : The closest tile index for each vehicle.
%     distancePedestrian : The distance of each pedestrian from the tile incentres.
%     idxPedestrian   : The closest tile index for each pedestrian.
%
% Copyright (c) 2018-2019, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
    
    distanceVehicle = [];
    idxVehicle = [];
    distancePedestrian = [];
    idxPedestrian = [];
    
    if ~isempty(vehicleTimestep)
        [ distanceVehicle, idxVehicle ] = pdist2(outputMap.inCentresTile(:,1:2), vehicleTimestep(:,2:3), 'euclidean', 'Smallest', 1);
    end
    
    if ~isempty(pedestrianTimestep)
        [ distancePedestrian, idxPedestrian ] = pdist2(outputMap.inCentresTile(:,1:2), pedestrianTimestep(:,2:3), 'euclidean', 'Smallest', 1);
    end
 
end

