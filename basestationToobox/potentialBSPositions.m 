function potentialPos = potentialBSPositions(outputMap, BS, map, linkBudget)
%potentialRSUPositions This function finds all the potential positions for
%  the RSUs on the map. If an already existing file with the potential
%  exists, then it is loaded. The different structures (outputMap, BS,
%  map) are checked against the loaded file to ensure that the correct
%  configuration exists.
%
%   For femtocells: The potential positions are the corners of the road
%   blocks and any other corners on the roads.
%   If two corners have a distance seperation longer than a given
%   threshold, then more potential positions are generated spliting the
%   road in equal segments.
%   For macrocells: A grid-like approach is followed. The user defines a
%   density for the RSUs, and they are placed, given this density in a grid
%   on the map.
%
%  Input  :
%     outputMap    : The map structure generated from the previous functions.
%     BS           : Structure containing all the informations about the
%                    basestations.
%     map          : Structure containing all map settings (filename, path,
%                    simplification tolerance to be used, etc).
%     linkBudget   : Structure containing all the informations for the
%                    linkbudget analysis of each different radio access technology.
%   
%  Output :
%     potentialPos : All the potential positions generated from this
%                      function for all the different RATs.
%
% Copyright (c) 2018-2019, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk

    global SIMULATOR
    
    % Start by not using the pre-processed file - this can be changed later. 
    usePrepFile = 0;
    
    [filePos,correctPath,fileName] = findPreprocessed(map,outputMap,BS,'potentialPos');
    
    % If a file has already exists, ask the user to load it or not
    if length(filePos) == 1
        usePrepFile = readYesNo('Would you like to use the previously preprocessed potential BS positions file?','Y','load');
    end
    
    if usePrepFile
        % Load the stored potential BS position file.
        load([filePos.folder '/' filePos.name])
        fprintf('File %s with all the potential BS positions was successfully loaded.\n', filePos.name);
    else
        tic
        fprintf('The new potential positions for all RATs will be identified.\n');
        
        % Identify the potential positions for the different modes (OSM-SUMO)
        % and types of cells.
        for i = 1:length(BS.rats)
            if strcmp(BS.(BS.rats{i}).ratType,'femto')
                if SIMULATOR.map == 0
                    potentialPos.(BS.rats{i}).pos = osmFemtoPositions( outputMap, BS, map, BS.rats{i} );
                elseif SIMULATOR.map == 1
                    potentialPos.(BS.rats{i}).pos = sumoFemtoPositions( outputMap, BS, map, BS.rats{i} );
                end
                potentialPos = addRATPolicy(potentialPos,BS,BS.rats{i},linkBudget);
            else
               if SIMULATOR.map == 0
                    [ pos, mountedBuildings ] = osmMacroPositions( outputMap, map );
               elseif SIMULATOR.map == 1
                    [ pos, mountedBuildings ] = sumoMacroPositions( outputMap, map );
               end
               potentialPos.(BS.rats{i}).pos = pos;
               potentialPos.(BS.rats{i}).mountedBuildings = mountedBuildings;
               potentialPos = addRATPolicy(potentialPos,BS,BS.rats{i},linkBudget);
            end
        end
        
        % Save the identified positions in an new file
        saveFile = readYesNo('Do you want to save the potential BS positions file?', 'Y');
        if saveFile
            if ~exist(correctPath,'dir')
                mkdir(correctPath);
            end
            
            % Add a unique random identifier in the file's name - this
            % helps with the easier loading later.
            fileSaveName = [ fileName{end} '_id' num2str(randi(999999)) '_potentialPos.mat' ];
            fprintf('Saving preprocessed potential BS positions file: %s\n', fileSaveName);
            save([correctPath '/' fileSaveName], 'potentialPos', 'outputMap', 'BS', 'map');
        else
            fprintf('The file with all the potential BS positions will not be saved\n.');
        end
        
        verbose('Identifying the potential positions for all RATs took: %f seconds.', toc); 
    end
    
end

