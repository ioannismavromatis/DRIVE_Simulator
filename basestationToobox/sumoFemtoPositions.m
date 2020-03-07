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
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
% email: ioannis.mavromatis@toshiba-bril.com

    global SIMULATOR
    tic
    
    junctionIDs = traci.junction.getIDList();
    laneIDs = traci.lane.getIDList();
    
    N = length(junctionIDs) + length(laneIDs);
    WaitMessage = parfor_wait(N, 'Waitbar', true);
    
    % Find all the junctions on the map in order to take the potential BS positions.
    tree = repmat(ceil(length(junctionIDs)/SIMULATOR.parallelWorkers),[1 SIMULATOR.parallelWorkers-1]);
    treeFinal = length(junctionIDs) - tree(1)*(SIMULATOR.parallelWorkers-1);
    tree = [ tree treeFinal ];

    % Get an array of all the junction shapes.
    for i = 1:length(junctionIDs)
        shape{i} = traci.junction.getShape(junctionIDs{i});
    end
    
    % Run in parallel based on the number of workers to speed up the
    % execution time.
    parfor (i = 1:SIMULATOR.parallelWorkers,SIMULATOR.parallelWorkers)
        warning('off', 'MATLAB:polyshape:boundary3Points')
        WaitMessage.Send;
        if i == 1
            toRun = 1:tree(i);
        elseif i == 8
            toRun = sum(tree(1:i-1))+1:length(junctionIDs);
        else
            toRun = sum(tree(1:i-1))+1:sum(tree(1:i));
        end
        
        polyObjParFor(i) = polyshape();
        for j = toRun(1):toRun(end)
            polyObjTmp = polyshape();
            x = [];
            y = [];
            shapeParFor = shape{j};
            for l = 1:length(shapeParFor)
                x(l)=shapeParFor{l}(1);
                y(l)=shapeParFor{l}(2);
            end
            if ~isempty(x) && ~isempty(y)
                polyObjTmp = polyshape(x,y,'Simplify',false);
            end
            polyObjParFor(i) = union(polyObjParFor(i),polyObjTmp);
        end
        
    end
    
    % Merge all the smaller union polygons into one
    polyObj = polyshape();
    for i = 1:SIMULATOR.parallelWorkers
        polyObj = union(polyObj,polyObjParFor(i));
    end
    

    % Given the lanes from SUMO, find where these lanes overlap with the
    % junctions. If there is an overlap it means that it is a road and is taken
    % into consideration. Also, find the lamppost positions --- i.e., for
    % junctions that are further than the distance threshold place more
    % basestations equally spaced on the road.
    
    potentialPos = [];
    lamppostPos = [];
    for i=1:length(laneIDs)
        WaitMessage.Send;
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
    lamppostPos = lamppostPos';
    lamppostPos = [ lamppostPos(:,2) lamppostPos(:,1) ];

% Add the 3rd dimension to make it a 3d system.
    potentialPos = [ potentialPos randi(BS.(ratName).height,length(potentialPos),1) ];
    
% For debugging purposes only
%     clf
%     plot(polyObj)      
%     hold on
%     plot(potentialPos(:,2),potentialPos(:,1),'ro')
%     hold on
%     plot(lamppostPos(:,2),lamppostPos(:,1),'g+')

    F = findall(0,'type','figure','tag','TMWWaitbar');
    delete(F)
    
    verbose('Calculating the potential femtocell basestation positions took: %f seconds.', toc);
end

