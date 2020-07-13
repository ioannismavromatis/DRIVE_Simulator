function [ losIDs, nLosIDs, losNlosStatus, distanceTiles, sortedIndexes, losRSS,nLosRSS,rssAll ] =...
                  perTileLosNLosCaching(outputMap,BS,linkBudget,map,ratName)
%PERTILELOSNLOSCACHING On a per tile-basis, find the surrounding tiles that 
%  are in LOS or NLOS and the correlating RSS value. Return all the values 
%  to the main program. This function works only for the femtocell RATs, as
%  this is considered the potential mobile-node - to - mobile-node
%  approach for this framework. This function also save the calculated
%  links or loads them from a file (if it already exists) to speed up the
%  execution time.
%
%  Input  :
%     outputMap      : The map structure extracted from the map file or loaded
%                      from the preprocessed folder and updated until this point.
%     BS             : Structure containing all the informations about the
%                      basestations.
%     linkBudget     : Structure containing all the informations for the
%                      linkbudget analysis of each different radio access technology.
%     map            : Structure containing all map settings (filename, 
%                      path, simplification tolerance to be used, etc).
%     ratName        : The name of RAT that will be used in this function.
%
%  Output :
%     losIDs         : Tile IDs that are in LOS between two tiles
%     nLosIDs        : Tile IDs that are in NLOS between two tiles
%     losNlosStatus  : The classification of each tile (LOS/NLOS) for a
%                      given BS - 0 is NLOS, 1 is LOS
%     distanceTiles  : The distance of each tile from a another given tile.
%     sortedIndexes  : The sorted indexes for the tile close to a ginen tile,
%                      sorted from the closest to the furthest one.
%     losRSS         : The received signal strength for the LOS tiles.
%     nLosRSS        : The received signal strength for the NLOS tiles.
%     rssAll         : The received signal strength for the all given tiles.
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
% email: ioannis.mavromatis@toshiba-bril.com

    
     % Start by not using the pre-processed file - this can be changed later.
    usePrepFile = 0;

    [filePos,correctPath,fileName] = findPreprocessed(map,outputMap,BS,'v2v');

    % If a file has already exists, ask the user to load it or not
    if length(filePos) == 1
        usePrepFile = readYesNo('Would you like to use the previously preprocessed potential BS positions file?','Y','load');
    end

    if usePrepFile
        % Load the stored los/nlos links file.
        load([filePos.folder '/' filePos.name])
        losIDs = []; nLosIDs = []; losRSS = []; nLosRSS = [];
        fprintf('File %s with all the V2V LOS/NLOS links was successfully loaded.\n', filePos.name);
    else
    
        [losIDs, nLosIDs, losNlosStatus, distanceTiles, sortedIndexes] = losNLosV2V(outputMap,BS,ratName);
        
        [losRSS,nLosRSS,rssAll] = calculateRSSV2V(losNlosStatus,distanceTiles,sortedIndexes,BS,linkBudget,ratName);   
            
        % Save the identified los/nlos interactions in an new file
        saveFile = readYesNo('Do you want to save all the V2V potential links in the corresponding file?', 'Y');
        if saveFile
            if ~exist(strcatEnhanced(correctPath),'dir')
                mkdir(strcatEnhanced(correctPath));
            end
            
            % Add a unique random identifier in the file's name - this
            % helps with the easier loading later.
            fileSaveName = [ fileName{end} '_' date '_v2v.mat' ];
            fprintf('Saving preprocessed potential V2V file: %s\n', fileSaveName);
%             save([correctPath '/' fileSaveName], 'losIDs','nLosIDs','distanceTiles','losNlosStatus',...
%                 'sortedIndexes', 'BS', 'map','outputMap','losRSS','nLosRSS','rssAll','-v7.3');
            save(strcatEnhanced([correctPath '/' fileSaveName]), 'distanceTiles','losNlosStatus',...
                'sortedIndexes', 'BS', 'map','outputMap','rssAll','-v7.3');
        else
            fprintf('The file with all the potential V2V links will not be saved\n.');
        end 
    end
    
end

