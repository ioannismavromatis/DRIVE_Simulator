function [ losLinks, nLosLinks, losIDs, nLosIDs, losNlosStatus ] = ...
           losNlosCalculation(sortedIndexes,raysToTest,buildingsToTest)
%losNlosCalculation Find the LOS and NLOS tiles for a given array of rays and
%  buildings. Each ray is tested if it intersects with a building wall and
%  if so, the link is considered as NLOS.
%
%  Input  :
%     sortedIndexes   : The sorted indexes for the tile close to BS, given
%                       from the closest to the furthest one.
%     raysToTest      : All the potential rays to be tested (started to
%                       finishing position) in pairs.
%     buildingsToTest : The edges of the buildings to test if they
%                       intersect with the given rays.
%
%  Output :
%     losLinks        : Logical array with all the LOS links.
%     nLosLinks       : Logical array with all the NLOS links.
%     losIDs          : Tile IDs that are in LOS with each BS.
%     nLosIDs         : Tile IDs that are in NLOS with each BS.
%     losNlosStatus   : The classification of each tile (LOS/NLOS) for a
%                       given BS - 0 is NLOS, 1 is LOS
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk

    outputLineSegmentIntersect = lineSegmentIntersect(raysToTest, buildingsToTest);

    %  Find the intersections with the road polygons
    interSect = sum(outputLineSegmentIntersect.intAdjacencyMatrix,2);
    interSect = logical(interSect);

    % Find the tile IDs that have LOS
    losLinks = find(interSect==0);
    losLinks = losLinks';
    nLosLinks = find(interSect==1);
    nLosLinks = nLosLinks';
    
    losIDs = sortedIndexes(~interSect);
    nLosIDs = sortedIndexes(interSect);
    
    % create a logical index array for easier manipulation
    losNlosStatus = zeros(1,length(sortedIndexes));
    losNlosStatus(losLinks) = 1;
    losNlosStatus = logical(losNlosStatus);
    
end


