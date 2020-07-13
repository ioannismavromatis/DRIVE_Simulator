function [ chosenBSpos,tilesCovered,highestRSS ] = bsPlacement(map,outputMap,BS,potentialBSPos,losIDs,nLosIDs,rssAll,sortedIndexes,losNlos)
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
%     highestRSS      : The highest RSS for the chosen BSs (per tile). 
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
% email: ioannis.mavromatis@toshiba-bril.com

    global SIMULATOR VERBOSELEVEL
        % Start by not using the pre-processed file - this can be changed later.
    usePrepFile = 0;

    [filePos,correctPath,fileName] = findPreprocessed(map,outputMap,BS,'bsPlacement',potentialBSPos);

    % If a file has already exists, ask the user to load it or not
    if length(filePos) == 1
        usePrepFile = readYesNo('Would you like to use the previously preprocessed potential BS positions file?','Y','load');
    end
    
    if usePrepFile
        % Load the stored los/nlos links file.
        load(strcatEnhanced([filePos.folder '/' filePos.name]))
        fprintf('File %s with all the selected basestations to be deployed was successfully loaded.\n', filePos.name);
    else
        for i = 1:length(BS.rats)
            if strcmp(BS.(BS.rats{i}).ratType,'femto')
                ratName = BS.rats{i};
                
                if strcmp(SIMULATOR.bsPlacement,'ga')
                    toSave = 'ga';
                    [ chosenBSpos.(ratName),tilesCovered.(ratName),highestRSS.(ratName) ] =...
                        gaSolver(BS,potentialBSPos,losIDs,nLosIDs,rssAll,outputMap,sortedIndexes,losNlos,ratName);
                elseif strcmp(SIMULATOR.bsPlacement,'greedy')
                    toSave = 'greedy';
                    [ chosenBSpos.(ratName),tilesCovered.(ratName),highestRSS.(ratName) ] =...
                        greedyAddition(BS,potentialBSPos,losIDs,nLosIDs,rssAll,outputMap,sortedIndexes,losNlos,map,ratName);
                elseif strcmp(SIMULATOR.bsPlacement,'random') 
                    toSave = 'random';
                    [ chosenBSpos.(ratName),tilesCovered.(ratName),highestRSS.(ratName) ] =...
                        randomChosen(BS,potentialBSPos,losIDs,nLosIDs,rssAll,outputMap,sortedIndexes,losNlos,ratName);
                else
                    disp('Wrong Basestation Placement algorithm was given. Please provide a correct name!')
                    error('Wrong Basestation Placement algorithm.');
                end
            else
                ratName = BS.rats{i};
                chosenBSpos.(ratName) = (1:length(potentialBSPos.(ratName).pos))';
                tilesCovered.(ratName) = tilesNumCovered(chosenBSpos.(ratName),losIDs{i},nLosIDs{i});
                [ ~,highestRSS.(ratName),~,~,~,~ ] = highestRSSValues(chosenBSpos.(ratName),outputMap,sortedIndexes{i}, rssAll{i},losNlos{i});
            end
        end
              
        % For debug purposes - plot the map with the potential BS positions
        % and the chosen ones from the above algorithms
        if VERBOSELEVEL >= 2
            clf
            mapPrint(outputMap);
            alpha(0.5)
            hold on
            plot(potentialBSPos.(ratName).pos(:,2),potentialBSPos.(ratName).pos(:,1),'gx','MarkerSize',20,'LineWidth',3)
            hold on
            plot(potentialBSPos.(ratName).pos(chosenBSpos,2),potentialBSPos.(ratName).pos(chosenBSpos,1),'mo','MarkerSize',20,'LineWidth',3)
            figure
            cdfplot(highestRSS)
        end
        
        % Save the identified los/nlos interactions in an new file
        saveFile = readYesNo('Do you want to save all the selected basestations to be deployed in the corresponding file?', 'Y');
        if saveFile
            if ~exist(strcatEnhanced(correctPath),'dir')
                mkdir(strcatEnhanced(correctPath));
            end
            
            % Add a unique random identifier in the file's name - this
            % helps with the easier loading later.
            fileSaveName = [ fileName{end} '_' date '_bsPlacement.mat' ];
            fprintf('Saving preprocessed selected basestations to be deployed file: %s\n', fileSaveName);
            save(strcatEnhanced([correctPath '/' fileSaveName]), 'chosenBSpos','tilesCovered',...
                'highestRSS','potentialBSPos','outputMap', 'BS', 'map',...
                'toSave');
        else
            fprintf('The file with all the selected basestations to be deployed will not be saved\n.');
        end 
        
    end
end

