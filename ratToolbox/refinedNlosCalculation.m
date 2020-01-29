function [ nLosLinks, nLosTileIDs, losNlosStatus ] = ...
    refinedNlosCalculation(nLosLinks,raysToTest,sortedIndexes,refinementValue)
%REFINEDLOSNLOSCALCULATION If a refinement value was given, all the tiles
%  that within this refinement region are consideres as NLOS tiles
%
%  Input  :
%     nLosLinks       : Logical array with all the NLOS links.
%     sortedIndexes   : The sorted indexes for the tile close to BS, given
%                       from the closest to the furthest one.
%     raysToTest      : All the potential rays to be tested (started to
%                       finishing position) in pairs.
%     refinementValue : The maximum number of tiles to be processed.
%
%  Output :
%     nLosLinks       : Logical array with all the NLOS links.
%     nLosIDs         : Tile IDs that are in NLOS with each BS.
%     losNlosStatus   : The classification of each tile (LOS/NLOS) for a
%                       given BS - 0 is NLOS, 1 is LOS
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk

    nLosLinks = [ nLosLinks refinementValue+1:length(raysToTest) ];
    nLosTileIDs = sortedIndexes(nLosLinks);
    losNlosStatus(1:length(sortedIndexes)) = 1;
    losNlosStatus(nLosLinks) = 0;
    losNlosStatus = logical(losNlosStatus);
end

