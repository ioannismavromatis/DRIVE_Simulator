function [vehicles,pedestrians] = getVehiclesAndPedestrians(sumo,vehicleIDs,pedestrianIDs,timeStep)
%GETVEHICLESANDPEDESTRIANS Parse all the vehicles and pedestrians for a
%  given timestep. The vehicles are at a form: [ ID posX posxY timestep vehicleType ],
%  while the pedestrians are at a form: [ ID posX posxY timestep ].
%
%  Input  :
%     sumo          : Structure containing all the SUMO settings (maximum
%                     number of vehicles, start time, end time, etc.)
%     vehicleIDs    : The vehicle IDs for the given timestep.
%     pedestrianIDs : The pedestrian IDs for the given timestep.
%     timeStep      : The current simulation time (in seconds).
%
%  Output :
%     vehicles      : Array containing all the information about the
%                     vehicles for the given timestep
%     pedestrians   : Array containing all the information about the
%                     pedestrians for the given timestep.
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
% email: ioannis.mavromatis@toshiba-bril.com
   
    vehicles = [];
    % Parse all the vehicles from this timestep
    for k = 1:length(vehicleIDs)
        vehicleClass = find(strcmp(traci.vehicle.getTypeID(vehicleIDs{k}),sumo.vehicleTypeAbbreviation)==1);
        vehicles = [ vehicles ; str2double(vehicleIDs{k}) traci.vehicle.getPosition(vehicleIDs{k}) timeStep vehicleClass ];
    end

    pedestrians = [];
    % Parse all the pedestrians from this timestep
    for k = 1:length(pedestrianIDs)
        pedestrians = [ pedestrians ; str2double(pedestrianIDs{k}) traci.person.getPosition(pedestrianIDs{k}) timeStep ];
    end
end

