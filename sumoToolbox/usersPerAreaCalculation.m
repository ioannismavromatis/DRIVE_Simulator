function [distanceVehicle,idxVehicle,distancePedestrian,idxPedestrian,usersPerArea] = usersPerAreaCalculation(outputMap,vehicles,pedestrians)
%USERSPERAREACALCULATION For all the given areas on them, either hexagonal
%  or squared, the number of user per area is calculated. This is the sum
%  of the user inside the buildings within the area added to the generated
%  number of vehicles and pedestrians on the city.
%
%  Input  :
%     outputMap       : The map structure containing all the map information.
%     vehicles        : Array containing all the information about the
%                       vehicles for the given timestep
%     pedestrians     : Array containing all the information about the
%                       pedestrians for the given timestep.
%
%  Output :
%     distanceVehicle : The distance of each vehicle from the area incentres.
%     idxVehicle      : The closest area incentre index for each vehicle.
%     distancePedestrian : The distance of each pedestrian from the area incentres.
%     idxPedestrian   : The closest area incentre index for each pedestrian.
%     usersPerArea    : The sum of the indoor user, the vehicles and the
%                       pedestrians for a given area on the map.
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
% email: ioannis.mavromatis@toshiba-trel.com
    
    distanceVehicle = [];
    idxVehicle = [];
    distancePedestrian = [];
    idxPedestrian = [];
    
    if ~isempty(vehicles)
        [ distanceVehicle, idxVehicle ] = pdist2(outputMap.inCentresArea(:,1:2), vehicles(:,2:3), 'euclidean', 'Smallest', 1);
    end
    
    if ~isempty(pedestrians)
        [ distancePedestrian, idxPedestrian ] = pdist2(outputMap.inCentresArea(:,1:2), pedestrians(:,2:3), 'euclidean', 'Smallest', 1);
    end
        
    [toRun,~] = size(outputMap.areaVerticesX);
    for i = 1:toRun
        usersPerArea(i) = sum(outputMap.usersPerBuilding(outputMap.buildingsInAreaLogicalIdx(:,i)));
        usersPerArea(i) = usersPerArea(i) + sum(idxVehicle == i) + sum(idxPedestrian == i);
    end
end

