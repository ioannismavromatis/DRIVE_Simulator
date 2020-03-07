function [randomValues,coordinates,initialX,initialY,interpX,interpY] = initialiseUsersPerBuilding(outputMap,runMode,map,sumo)
%INITIALISEUSERSPERBUILDING Initialise the information required for the
%  usersPerBuilding function. See that for more information.
%
%  Input  :
%     outputMap    : The map structure extracted from the map file or loaded
%                    from the preprocessed folder
%     sumo         : Structure containing all the SUMO settings (maximum
%                    number of vehicles, start time, end time, etc.)
%
%  Output :
%     randomValues : Array containing all the information about the vehicles
%                    for the entire simulation time.
%     coordinates  : The edge of the map (rounded to 1 decimal point).
%     initialX     : A vector with five values equally spaced between the
%                    start and the end of the map (horizontal).
%     initialY     : A vector with five values equally spaced between the
%                    start and the end of the map (vertical).
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
% email: ioannis.mavromatis@toshiba-bril.com

    % round the coordinates for easier manipulation later
    coordinates = [ floor(outputMap.bbox(1,1)) ceil(outputMap.bbox(1,2)) ;
        floor(outputMap.bbox(2,1)) ceil(outputMap.bbox(2,2)) ];
    L = 10;
    
    initialX = linspace(coordinates(1,1),coordinates(1,2),5);
    initialY = linspace(coordinates(2,1),coordinates(2,2),5);
    interpX = linspace(coordinates(1,1),coordinates(1,2),map.densitySimplification);
    interpY = linspace(coordinates(2,1),coordinates(2,2),map.densitySimplification);
    
    if strcmp(runMode,'osm')
        randomValues = rand(1,length(initialX)*length(initialY)*L*10);
    else
        randomValues = rand(1,length(initialX)*length(initialY)*L*sumo.endTime);
    end
end

