function tilesCovered = tilesNumCovered(cRSUpos,losTileIDs,nLosTileIDs)
    tilesLosIDs=reshape(cell2mat(losTileIDs(cRSUpos)),[],1);
    tilesNLosIDs=reshape(cell2mat(nLosTileIDs(cRSUpos)),[],1);
    
    tilesCovered.tilesLosIDs = unique(tilesLosIDs,'stable');
    tilesCovered.tilesNLosIDs = unique(tilesNLosIDs,'stable');
    
    tilesCovered.allIDs= unique([tilesCovered.tilesLosIDs ; tilesCovered.tilesNLosIDs]);
    
    tilesCovered.losNumber = length(tilesCovered.tilesLosIDs);
    tilesCovered.nLosNumber = length(tilesCovered.tilesNLosIDs);
    tilesCovered.totalNumber = length(tilesCovered.allIDs);
end
