function [ tilesNum, tilesIDs ] = tilesNumCovered(cRSUpos,losTileIDs)
    tilesIDs=reshape(cell2mat(losTileIDs(cRSUpos)),[],1);
    tilesIDs = unique(tilesIDs,'stable');
    
    tilesNum = length(tilesIDs);
end
