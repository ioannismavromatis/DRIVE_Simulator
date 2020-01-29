function [ potentialPos ] = osmFemtoPositions( outputMap, BS, map, ratName )
%osmFemtoPositions This function finds all the potential positions for
%  the BSs on the map. The potential positions are the corners of the road
%  blocks and any other corners on the roads.
%   If two corners have a distance seperation longer than a given
%   threshold, then more potential positions are generated spliting the
%   road in equal segments.
%
%  Input  :
%     outputMap    : The map structure extracted from the map file or loaded
%                    from the preprocessed folder and updated until this point.
%     BS           : Structure containing all the informations about the
%                    basestations.
%     map          : Structure containing all map settings (filename, path, 
%                    simplification tolerance to be used, etc).
%    ratName       : The name of RAT that will be used later.
%
%  Output :
%     potentialPos : All the potential positions generated from this function.
%
% Copyright (c) 2018-2019, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk

    tic
    
    % Initialise the potential positions - all the corners of the roads.
    potentialPosInitial(:,:) = outputMap.roadsPolygons(:,[2 3]);
    
    %% This is commented out - the edge tolerance will be used in a different way
    % Calculate the minimum and maximum coordinates for the potential
    % positions based on the edge tolerance -- to avoid the edge effect.
%     minX = min(outputMap.buildings(:,3)) + mapSettings.edgeTolerance;
%     minY = min(outputMap.buildings(:,2)) + mapSettings.edgeTolerance;
%     maxX = max(outputMap.buildings(:,3)) - mapSettings.edgeTolerance;
%     maxY = max(outputMap.buildings(:,2)) - mapSettings.edgeTolerance;

    
    % Remove the corners that are outside of the edge threshold effect.
%     outOfBounds = [ find(potentialPosInitial(:,2)>maxX);...
%                     find(potentialPosInitial(:,2)<minX);...
%                     find(potentialPosInitial(:,1)>maxY);...
%                     find(potentialPosInitial(:,1)<minY)];
%     outOfBounds = unique(outOfBounds);
%     potentialPosInitial(outOfBounds, :)=[];

    % Initialise the positions that will be added to the potential ones.
    lamppostPos = zeros(0);
    
    % Generate all the new positions based on the distance threshold for
    % the RSUs.
    for i=1:length(potentialPosInitial)-1
        if ~isnan(potentialPosInitial(i,:))
            if ~isnan(potentialPosInitial(i+1,:))
                % The distance between two corners of the block.
                distance = distancePoints(potentialPosInitial(i,:),potentialPosInitial(i+1,:));
                lamppostPos = [ lamppostPos ...
                    addLamppostPositions(distance,[potentialPosInitial(i,:);potentialPosInitial(i+1,:)]',map) ]; 
            end
        end
    end

    % Keep the unique positions from all the potential positions calculated
    % - corners of the roads and new positions.
    potentialPos = [ potentialPosInitial ; lamppostPos' ];
    [ potentialPos, ~ ] = unique(potentialPos, 'rows','stable');

    % Remove the potential positions that are not on the edge of the road
    % polygon and return the potential positions.
    vertices = outputMap.roadsPolygons(:,[2 3]);
    edges = [vertices vertices([2:end 1], :)];

    pointsOnEdge = isPointOnEdge(potentialPos,edges);
    toRemove = find(any(pointsOnEdge,2)==0);
    potentialPos(toRemove,:)=[];
    
    toRemove = zeros(length(potentialPos),1);
    for i = 1:length(toRemove)
        if potentialPos(i,1)<outputMap.bbox(2,1) ||...
           potentialPos(i,1)>outputMap.bbox(2,2) ||...
           potentialPos(i,2)<outputMap.bbox(1,1) ||...
           potentialPos(i,2)>outputMap.bbox(1,2)
            toRemove(i) = 1;
        end
    end
    potentialPos(logical(toRemove),:) = [];
    
    % Add the 3rd dimension to make it a 3d system.
    potentialPos = [ potentialPos randi(BS.(ratName).height,length(potentialPos),1) ];

    verbose('Calculating the potential femtocell basestation positions took: %f seconds.', toc);
end

