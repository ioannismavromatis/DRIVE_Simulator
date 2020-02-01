function [ chosenRSUpos, tilesCovered,tilesCoveredIDs,highestRSS ] = bsPlacement(map,outputMap,BS,potentialBSPos,losIDsPerRAT,initialLosTilesRSS,ratName)
%BSPLACEMENT This function executed the chosen algorithm for the BS
%   placement, chosen by the end user. The three algorithms provided are
%   just examples of the simulator's functionality. Other algorithms can be
%   added to further extend SMARTER's capabilities.
%
%  Input  :
%     BS           : Structure to be filled with the basestation information
%     potentialPos : All the potential positions generated from this
%                      function for all the different RATs.
%     losIDsPerRAT : Tile IDs that are in LOS with each BS.
%     initialLosTilesRSS : The received signal strength for the LOS tiles.
%     outputMap    : The map structure extracted from the map file or loaded
%                    from the preprocessed folder and updated until this point.
%     ratName      : The name of RAT that will be used in this function.
%
%  Output :
%     chosenRSUpos    : The IDs of the chosen BSs.
%     tilesCovered    : The tiles covered by the selected BSs.
%     tilesCoveredIDs : The tile IDs that are covered.
%     highestRSS      : The highest RSS for the chosen BSs (per tile). 
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk

    global SIMULATOR
        % Start by not using the pre-processed file - this can be changed later.
    usePrepFile = 0;

    [filePos,correctPath,fileName] = findPreprocessed(map,outputMap,BS,'bsPlacement',potentialBSPos);

    % If a file has already exists, ask the user to load it or not
    if length(filePos) == 1
        usePrepFile = readYesNo('Would you like to use the previously preprocessed potential BS positions file?','Y','load');
    end
    
    if usePrepFile
        % Load the stored los/nlos links file.
        load([filePos.folder '/' filePos.name])
        fprintf('File %s with all the selected basestations to be deployed was successfully loaded.\n', filePos.name);
    else
        if strcmp(SIMULATOR.bsPlacement,'ga')
            [ chosenRSUpos,tilesCovered,tilesCoveredIDs,highestRSS ] =...
                gaSolver(BS,potentialBSPos,losIDsPerRAT,initialLosTilesRSS,outputMap,ratName);
        elseif strcmp(SIMULATOR.bsPlacement,'greedy')
            [ chosenRSUpos,tilesCovered,tilesCoveredIDs,highestRSS ] =...
                greedyAddition(BS,potentialBSPos,losIDsPerRAT,initialLosTilesRSS,outputMap,ratName);
        elseif strcmp(SIMULATOR.bsPlacement,'random')   
            [ chosenRSUpos,tilesCovered,tilesCoveredIDs,highestRSS ] =...
                randomChosen(BS,potentialBSPos,losIDsPerRAT,initialLosTilesRSS,outputMap,ratName);
        else
            disp('Wrong Basestation Placement algorithm was given. Please provide a correct name!')
            error('Wrong Basestation Placement algorithm.');
        end
              
        % Save the identified los/nlos interactions in an new file
        saveFile = readYesNo('Do you want to save all the selected basestations to be deployed in the corresponding file?', 'Y');
        if saveFile
            if ~exist(correctPath,'dir')
                mkdir(correctPath);
            end
            
            % Add a unique random identifier in the file's name - this
            % helps with the easier loading later.
            fileSaveName = [ fileName{end} '_id' num2str(randi(999999)) '_bsPlacement.mat' ];
            fprintf('Saving preprocessed selected basestations to be deployed file: %s\n', fileSaveName);
            save([correctPath '/' fileSaveName], 'chosenRSUpos','tilesCovered',...
                'tilesCoveredIDs','highestRSS','potentialBSPos','outputMap', 'BS', 'map');
        else
            fprintf('The file with all the selected basestations to be deployed will not be saved\n.');
        end 
        
    end
end

