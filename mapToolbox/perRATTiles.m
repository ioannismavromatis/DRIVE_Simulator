function [ losIDs,nLosIDs,losNlosStatus,distanceTiles,sortedIndexes,losRSS,nLosRSS,rssAll,...
           distanceBuildings, sortedIndexesBuildings, rssBuildings ] = ...
                 perRATTiles(outputMap,potentialBSPos,BS,map)
%perRATTiles Find the LOS and NLOS tiles for each RAT used. 
%  Calculate the RSS per basestation for these tiles using the existing   
%  pathloss models given before. Return everything in the form of a struct.
%  This function iterates for all the given RATs and returns a cell array
%  for each one of them with the calculated information.
%
%  Input  :
%     outputMap      : The map structure extracted from the map file or loaded
%                      from the preprocessed folder and updated until this point.
%     potentialBSPos : All the potential positions generated from this
%                      function for all the different RATs.
%     BS             : Structure containing all the informations about the
%                      basestations.
%     map            : Structure containing all map settings (filename, 
%                      path, simplification tolerance to be used, etc).
%
%  Output :
%     losIDs         : Tile IDs that are in LOS with each BS.
%     nLosIDs        : Tile IDs that are in NLOS with each BS.
%     losNlosStatus  : The classification of each tile (LOS/NLOS) for a
%                      given BS - 0 is NLOS, 1 is LOS
%     distanceTiles  : The distanceTiles of each tile from a given BS.
%     sortedIndexes  : The sorted indexes for the tile close to BS, given
%                      from the closest to the furthest one.
%     losRSS         : The received signal strength for the LOS tiles.
%     nLosRSS        : The received signal strength for the NLOS tiles.
%     rssAll         : The received signal strength for the all given tiles.
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
% email: ioannis.mavromatis@toshiba-bril.com
    
    % Start by not using the pre-processed file - this can be changed later.
    usePrepFile = 0;

    [filePos,correctPath,fileName] = findPreprocessed(map,outputMap,BS,'losNlosRAT',potentialBSPos);

    % If a file has already exists, ask the user to load it or not
    if length(filePos) == 1
        usePrepFile = readYesNo('Would you like to use the previously preprocessed potential BS positions file?','Y','load');
    end
    
    if usePrepFile
        % Load the stored los/nlos links file.
        load([filePos.folder '/' filePos.name])
        fprintf('File %s with all the LOS/NLOS links was successfully loaded.\n', filePos.name);
    else
        for i = 1:length(BS.rats)

        
            [ losIDs{i}, nLosIDs{i}, losNlosStatus{i}, distanceTiles{i}, sortedIndexes{i} ] = ...
                   losNLosTilesPerRAT(outputMap,potentialBSPos,BS,BS.rats{i});

            [losRSS{i},nLosRSS{i},rssAll{i}] = calculateRSSV2I(losNlosStatus{i},distanceTiles{i},sortedIndexes{i},potentialBSPos.(BS.rats{i}),BS,BS.rats{i});   
            
            [ distanceBuildings{i}, sortedIndexesBuildings{i}, rssBuildings{i} ] = ...
                calculateRSSBStoBuilding(outputMap,potentialBSPos.(BS.rats{i}),BS,BS.rats{i});
        end
        
        % Save the identified los/nlos interactions in an new file
        saveFile = readYesNo('Do you want to save all the V2I potential links in the corresponding file?', 'Y');
        if saveFile
            if ~exist(correctPath,'dir')
                mkdir(correctPath);
            end
            
            % Add a unique random identifier in the file's name - this
            % helps with the easier loading later.
            fileSaveName = [ fileName{end} '_' date '_losNlosRAT.mat' ];
            fprintf('Saving preprocessed potential losNlosRAT file: %s\n', fileSaveName);
            save([correctPath '/' fileSaveName], 'losIDs','nLosIDs','losNlosStatus','distanceTiles',...
                'sortedIndexes','losRSS','nLosRSS','rssAll', 'potentialBSPos','outputMap', 'BS', 'map',...
                'distanceBuildings','sortedIndexesBuildings','rssBuildings');
        else
            fprintf('The file with all the potential V2I links will not be saved\n.');
        end 
    end
end

