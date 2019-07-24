function potentialPos = sumoFemtoPositions(outputMap, BS, map, ratName)
%sumoFemtoPositions Find the potential BS positions for the femtocell
%  BSs, when SUMO is being used.
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
    polyObj = polyshape();

% Find all the junctions on the map in order to take the potential BS
% positions
    warning('off', 'MATLAB:polyshape:boundary3Points')
    junctionIDs = traci.junction.getIDList();
    for i = 1:length(junctionIDs)
        shape = traci.junction.getShape(junctionIDs{i});
        x = [];
        y = [];
        for j = 1:length(shape)
            x(j)=shape{j}(1);
            y(j)=shape{j}(2);
        end
        if ~isempty(x) && ~isempty(y)
            polyObjTmp = polyshape(x,y,'Simplify',false);
        end
        polyObj = union(polyObj,polyObjTmp);
    end

% Given the lanes from SUMO, find where these lanes overlap with the
% junctions. If there is an overlap it means that it is a road and is taken
% into consideration. Also, find the lamppost positions --- i.e., for
% junctions that are further than the distance threshold place more
% basestations equally spaced on the road.
    potentialPos = [];
    lamppostPos = [];
    laneIDs = traci.lane.getIDList();
    for i=1:length(laneIDs)
        shape = traci.lane.getShape(laneIDs{i});
        l = length(shape);
        shapeMatrix = cell2mat(shape);
        shapeMatrix = reshape(shapeMatrix,2,l);

        for j = 2:l
            distance = pdist(shapeMatrix(:,j-1:j)','euclidean');
            lamppostPos = [ lamppostPos addLamppostPositions(distance,shapeMatrix(:,j-1:j)',map) ];     
        end

        potentialPos = [ potentialPos shapeMatrix ];
    end


% Get all the positions that are on the vertices of the junction polygon.   
% Reshape the polygon matrix to comply with the required input of
% inpoly2 and findNodesEdges, i.e. each polygon is represented by a
% number of points having the first and the last point being the same.
    tmp = polyObj.Vertices;
    nanToTakeIntoAccount = find(isnan(tmp(:,1))==1);
    for i = 1:length(nanToTakeIntoAccount)
        if i==1
            idx = 1;
        else
            idx = nanToTakeIntoAccount(i-1) + 1;
        end
        tmp(nanToTakeIntoAccount(i),:) = tmp(idx,:);
    end
    tmp(end+1,:) = tmp(nanToTakeIntoAccount(end) + 1,:);
    
    [ nodes, edges ] = findNodesEdges(tmp);
    [~,on ] = inpoly2(potentialPos', nodes, edges);
    
%     [~,on] = inpolygon(potentialPos(1,:),potentialPos(2,:),polyObj.Vertices(:,1),polyObj.Vertices(:,2));
    potentialPos = potentialPos(:,on');

% Add the lamppost positions in the potentials positions as well    
    potentialPos = [ potentialPos lamppostPos ];
    
% Remove the positions that are outside of the map boundaries
    toRemove = zeros(length(potentialPos),1);
    for i = 1:length(toRemove)
        if potentialPos(1,i)<outputMap.bbox(2,1) ||...
                potentialPos(1,i)>outputMap.bbox(2,2) ||...
                potentialPos(2,i)<outputMap.bbox(1,1) ||...
                potentialPos(2,i)>outputMap.bbox(1,2)
            toRemove(i) = 1;
        end
    end
    potentialPos(:,logical(toRemove)) = [];
    
% Change matrix orientation to be compatible with the OSM scripts as well.    
    potentialPos = potentialPos';
    potentialPos = [ potentialPos(:,2) potentialPos(:,1) ];

% Add the 3rd dimension to make it a 3d system.
    potentialPos = [ potentialPos randi(BS.(ratName).height,length(potentialPos),1) ];
    
% For debugging purposes only
%     clf
%     plot(polyObj)      
%     hold on
%     plot(potentialPos(:,2),potentialPos(:,1),'ro')

    verbose('Calculating the potential femtocell basestation positions took: %f seconds.', toc);
end

