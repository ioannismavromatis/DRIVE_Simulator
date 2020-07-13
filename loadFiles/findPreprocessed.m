function [filePos,correctPath,fileName] = findPreprocessed(map,outputMap,BS,str,potentialPos)
%findPreprocessed Find the information about the preprocessed potential 
%  BS positions and or tile LOS/NLOS information. 
%  This function checks if the saved files are correct, and if so the user
%  can choose to load them into the workspace, reducing the execution time.
%
%  Input  :
%     map          : Structure containing all map settings (filename, path,
%                    simplification tolerance to be used, etc).
%     outputMap    : The map structure generated from the previous functions.
%     BS           : Structure containing all the informations about the
%                    basestations.
%     str          : Part of the of the file to be loaded (either
%                    "potentialPos" or "losNlosRAT").
%     linkBudget   : Structure containing all the informations for the
%                    linkbudget analysis of each different radio access technology.
%     potentialPos : All the potential positions generated for all RATs.
%
%  Output :
%     filePos      : Contains all the information about the file to be loaded.
%     correctPath  : The path to the folder to look for all the saved files.
%     fileName     : A cell structure with the names-of-interest for the
%                    files to be loaded.
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
% email: ioannis.mavromatis@toshiba-bril.com

    global SIMULATOR
	
    % Run if the option of loading pre-processed is given in the settings
    if SIMULATOR.load ~= 0
        % Path to the pre-processed maps.
        pathFile = SIMULATOR.pathPreprocessed;
        if SIMULATOR.map == 0
            pathFile = strcatEnhanced([ pathFile '/osm' ]);
        else
            pathFile = strcatEnhanced([ pathFile '/sumo' ]);
        end

        % find all the files with potential BS positions saved before
        [ path, ~, ~ ] = fileparts(map.file);
        fileName = strsplitEnhanced(path,'/');
        correctPath = strcatEnhanced([ pathFile '/' fileName{end} ]);
        filePos = dir(strcatEnhanced([ correctPath '/*' str '.mat']));

        % find the correct file to load -- test against the
        % outputMap,BS,map structures
        toRemove = [];
        for i=1:length(filePos)
            if nargin==4
                tmp = ~testSavedFile(filePos(i),outputMap,BS,map);
            elseif nargin>4
                tmp = ~testSavedFile(filePos(i),outputMap,BS,map,potentialPos);
            end
            if tmp
                toRemove = [ toRemove i ];
            end
        end
        filePos(toRemove)=[];
    end
end

