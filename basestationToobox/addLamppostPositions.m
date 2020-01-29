function newPositions = addLamppostPositions(distance,matrixPos,map)
%ADDLAMBPOSTPOSITIONS Find the lamppost positions on the map and add a 
%  basestation on each one of them
%   Given the lanes from SUMO, find where these lanes overlap with the
%   junctions. If there is an overlap it means that it is a road and is 
%   taken into consideration. Also, find the lamppost positions --- i.e.,
%   for junctions that are further than the distance threshold place more
%   basestations equally spaced on the road.
%
%  Input  :
%     distance     : The distance between two junctions.
%     matrixPos    : The matrix with the two positions (junctions) that 
%                    should be considered.
%     map          : Structure containing all map settings (filename, path,
%                    simplification tolerance to be used, etc).
%
%  Output :
%     newPositions : The list with all the new positions for all the newly
%                    calculated potential basestations on the lampposts
%                    and the ones in between.
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk

    newPositions = [];
    if distance > map.femtoDistanceThreshold
        % Calculate how many new positions should be added.
        times = ceil(distance/map.femtoDistanceThreshold);
        newPointDistance = distance/times;
        angle = atan2d(matrixPos(2,2)-matrixPos(1,2),matrixPos(2,1)-matrixPos(1,1));
        
        % Add the positions.
        for k = 1:times-1
            y = newPointDistance*cosd(angle) + matrixPos(1,1);
            x = newPointDistance*sind(angle) + matrixPos(1,2);
            newPositions = [ newPositions [y ; x]];
        end
    end
    
    % for debug purposes only
%     clf
%     plot(matrixPos(:,1),matrixPos(:,2),'ro')
%     hold on
%     plot(newPositions(1),newPositions(2),'b*')
end

