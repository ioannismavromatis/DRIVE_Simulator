function correct = testSavedFile(filePos,outputMapTmp,BStmp,maptmp,potentialPosTmp)
%TESTSAVEDFILE Test if the saved filed was saved using exactly the same
%  configuration parameters. If not, the file will be generated again.
%
%  Input  :
%     filePos         : Contains all the information about the file to be loaded.
%     outputMapTmp    : The map structure generated from the previous functions.
%     BStmp           : Structure containing all the informations about the
%                       basestations.
%     maptmp          : Structure containing all map settings (filename, path,
%                       simplification tolerance to be used, etc).
%     potentialPosTmp : All the potential positions generated for all RATs.
%  Output :
%     correct         : Logical variable showing if the saved file is
%                       correct or not.
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
% email: ioannis.mavromatis@toshiba-bril.com

    global SIMULATOR
    
    load(strcatEnhanced([filePos.folder '/' filePos.name]));
    correctPos = 1;
    if nargin>4
        if ~isequal(potentialPosTmp,potentialBSPos)
            correctPos = 0;
        end
        if exist('toSave','var')
            if ~strcmp(SIMULATOR.bsPlacement,toSave)
                correctPos = 0;
            end
        end
    end
    
    
    
    if contains(filePos.folder,'osm')
        % when an OSM is loaded, the roadsPolygons field contains NaN
        % values. isequal function used later, doesn't like NaN values,
        % therefore these two fields are temporarily excluded from the comparison
        outputMapTmp = rmfield(outputMapTmp,'roadsPolygons');
        outputMap = rmfield(outputMap,'roadsPolygons');
    end
    
    if isequal(outputMapTmp,outputMap) && isequal(BStmp,BS) && isequal(maptmp,map)            
        correct = 1*correctPos;
    else
        correct = 0;
    end
    
end

