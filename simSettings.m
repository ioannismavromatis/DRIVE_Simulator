% simSettings The core simulation settings. 
%  This file contains all the necessary information to initialise the
%  simulation framework. The simulation parameters referring to the
%  communication planes can be found under ratToolbox/available.
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk

%% Verbosity level of the simulation -- affects the number of messages printed on the command prompt
global VERBOSELEVEL
VERBOSELEVEL = 1; % Use 0 to print nothing, 1 to print some
                  % messages in the command line, 2 to print maps
                                    
%% Simulator Settings              
global SIMULATOR 
SIMULATOR.scenario = 'sumo'; % three scenarios provided, i.e. 'v2v', 'sumo', 'osm'
SIMULATOR.parallelRun = 1;
SIMULATOR.parallelWorkers = 8;
SIMULATOR.sumoPath = '/usr/local/bin';
SIMULATOR.map = 1; % give 0 to parse an OSM map, 1 to parse map from SUMO
SIMULATOR.load = 2; % Choose if the preprocessed files will be loaded - 0 process from scratch, 1 ask user, 2 load all (if existing)
SIMULATOR.pathPreprocessed = './mobilityFiles/preprocessedFiles';

%% SUMO Settings
sumo.routeFile = './mobilityFiles/sumoFiles/londonSmall/londonSmall.sumocfg';
sumo.maxVehicleNumber = 200; % maximum number of vehicles per timestep - set to zero if all vehicles are to be considered
sumo.startTime = 0;
sumo.endTime = 200;
sumo.maxPedestrianNumber = 200; % maximum number of pedestrians per timestep - set to zero if all pedestrians are to be considered
sumo.gui = 0; % set to 1 if the user wants to use the SUMO GUI

%% Lookup Tables Vehicles Types
sumo.vehicleTypes= {'Ambulance';'Passenger'};
sumo.vehicleTypeAbbreviation= {'amb' ; 'pas'};

%% Map Settings
map.file = './mobilityFiles/sumoFiles/londonSmall/londonSmall.osm.xml'; % manhattanLarge - londonSmall - smartJunction
map.simplificationTolerance = 10;
map.edgeTolerance = 100;
map.tileSize = 20; % for square tiles: length of side - for hexagons: length of short diagonal
map.tileShape = 2; % give 1 for hexagon and 2 for square
map.area = 200; % give the size of the map tiles to be processed or give 0
                 % to be ignored  --- for square areas: length of side - for 
                 % hexagons: length of short diagonal
map.areaShape = 2; % give 1 for hexagon and 2 for square
map.maxUsersPerBuilding = 100; % the maximum number of users at the user density peak
map.densitySimplification = 50;

%% Structures used for the basestations and the linkbudget analysis
BS = struct;
linkBudget = struct;

%% Constants used during the simulation time
SIMULATOR.constant.c = 299792458; % speed of light - in m/s
