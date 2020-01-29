function [ vehicleStruct, pedestrianStruct ] = parseMobility( sumo, vehicle, pedestrian )
%PARSEMOBILITY This function parses all positions of the pedestrians and
%  the vehicles, and returns a structure with all the information.
%
%  Input  :
%     sumo             : Structure containing all the SUMO settings (maximum
%                        number of vehicles, start time, end time, etc.)
%     vehicles         : Array containing all the information about the
%                        vehicles for the entire simulation time.
%     pedestrians      : Array containing all the information about the
%                        pedestrians for the entire simulation time.
%
%  Output :
%     vehicleStruct    : A structure containing all the information about 
%                        the vehicles (type, position at each timeslot, etc.)
%     pedestrianStruct : A structure containing all the information about the
%                        pedestrians (type, position at each timeslot, etc.)
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
    
    global SIMULATOR
    
    tic
    if SIMULATOR.map == 0
        vehicleStruct = [];
        pedestrianStruct = [];
        return;
    end
    
    % Build struct with each one vehicle seperately
    uniqueVehicleIDs = unique(vehicle(:,1));
    
    emptyCounter = 0; % Counter to remove non-existing vehicles in SUMO file (ID missing)
    missingIDs = [];
    
    for nodeIndexTmp = 1:max(uniqueVehicleIDs)
        vArrayTmp = find(vehicle(:,1) == nodeIndexTmp-1);
        
        if ~isempty(vArrayTmp)
            
            vehicleStruct.vehNode(nodeIndexTmp - emptyCounter) = ...
                struct('time', vehicle(vArrayTmp,4),...
                'x', vehicle(vArrayTmp,2),...
                'y', vehicle(vArrayTmp,3),...
                'vehicleType', vehicle(vArrayTmp(1),5));
        else
            emptyCounter = emptyCounter + 1;
            missingIDs = [ missingIDs nodeIndexTmp-1 ];
        end
    end
    
    vehicleStruct.simTime = sumo.endTime - sumo.startTime;
    vehicleStruct.simStep = vehicleStruct.vehNode(1).time(2) - vehicleStruct.vehNode(1).time(1);
    vehicleStruct.missingIDs = missingIDs;
    vehicleStruct.type = unique(vehicle(:,5),'stable');
    
    if isempty(pedestrian)
        pedestrianStruct = struct;
        return
    end
    % Build struct with each one pedestrian seperately
    uniquePedestrianIDs = unique(pedestrian(:,1));
    
    emptyCounter = 0; % Counter to remove non-existing pedestrians in SUMO file (ID missing)
    missingIDs = [];
    
    for nodeIndexTmp = 1:max(uniquePedestrianIDs)
        vArrayTmp = find(pedestrian(:,1) == nodeIndexTmp-1);
        
        if ~isempty(vArrayTmp)
            
            pedestrianStruct.pedNode(nodeIndexTmp - emptyCounter) = ...
                struct('time', pedestrian(vArrayTmp,4),...
                'x', pedestrian(vArrayTmp,2),...
                'y', pedestrian(vArrayTmp,3));
        else
            emptyCounter = emptyCounter + 1;
            missingIDs = [ missingIDs nodeIndexTmp-1 ];
        end
    end
    
    pedestrianStruct.simTime = sumo.endTime - sumo.startTime;
    pedestrianStruct.simStep = pedestrianStruct.pedNode(1).time(2) - pedestrianStruct.pedNode(1).time(1);
    pedestrianStruct.missingIDs = missingIDs;
    
    verbose('Parsing the mobility required in total %f seconds.', toc);
end

