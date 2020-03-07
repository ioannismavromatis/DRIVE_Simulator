function outputMap = loadMap( map, sumo )
%loadMap Loads either a pre-processed map file or generates a new structure
%based on an input file
%   Saves pre-processed network file so there is so that the processing
%   needs to be done only ones or if the preprocessed file exists, it is
%   loaded in the simulator.
%
%  Input  :
%     map       : Structure containing all map settings (filename, path,
%                 simplification tolerance to be used, etc).
%     sumo      : Structure containing all the SUMO settings (maximum
%                 number of vehicles, start time, end time, etc.)
% 
%  Output :
%     outputMap : The map structure extracted from the map file or loaded
%                 from the preprocessed folder
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
% email: ioannis.mavromatis@toshiba-bril.com
    
    global SIMULATOR
    
    % Path to the pre-processed maps.
    pathFile = SIMULATOR.pathPreprocessed;
    if SIMULATOR.map == 0
        pathFile = [ pathFile '/osm' ];
        
        % Check if the file is in the correct format.
        if ~(contains(map.file,'osm') || contains(map.file,'OSM'))
            error('This is not an OSM XML file. Please, make sure that the file is correct');
        end
        
        % Parcing an OSM map requires the file to be in '$name$.osm' format
        [ path, ~, ~ ] = fileparts(map.file);
        fileName = strsplit(map.file,'/');
        correctName = strsplit(fileName{end},'.');
        map.fileCorrectName = [ path '/' correctName{1} '.osm' ];
    else
        % If parcing a SUMO map was chosen
        pathFile = [ pathFile '/sumo' ];
        fileName = strsplit(sumo.routeFile,'/');
        correctName = strsplit(fileName{end},'.');        
    end
    
    % Start by not using the pre-processed map - this can be changed later. 
    usePrepFile = 0;
       
    %% Loading or saving a map file
  
    % If the map file has already been processed before, ask the
    % user if it should be loaded or not.
    if length(dir([pathFile '/' correctName{1} '/' correctName{1} '_preProc.mat'])) == 1
        usePrepFile = readYesNo('Would you like to use the previously preprocessed network file?','Y','load');
    end
    
    if usePrepFile
        % Load the stored map file and print it.
        fprintf('Loading preprocessed map file: %s\n', correctName{1});
        load([pathFile '/' correctName{1} '/'  correctName{1} '_preProc.mat'],...
            'outputMap');
        
        printMap = readYesNo('Would you like to print the map?','N');
        if printMap
            mapPrint(outputMap);
        end
    else
        % Process the new map file.
        fprintf('Parse the map file: %s\n', correctName{1});
        if SIMULATOR.map == 0
            outputMap = parseOSM(map);
        elseif SIMULATOR.map == 1
            outputMap = parseSUMOMap(map,sumo);
        end
        
        % save the processed map
        saveFile = readYesNo('Do you want to save the map file?', 'Y');
        if saveFile
            if ~exist([pathFile '/' correctName{1} ],'dir')
                mkdir([pathFile '/' correctName{1} ]);
            end
            fprintf('Saving preprocessed map file: %s\n', correctName{1});
            save([pathFile '/' correctName{1} '/' correctName{1} '_preProc.mat'],...
                'outputMap');
        else
            fprintf('Map file will not be saved\n.');
        end
    end

end

