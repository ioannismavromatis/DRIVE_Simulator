function simplPolygons = simplifyPolygons(polygons,map)
%simplifyPolygons This function simplifies the polygon outline using the
%  Douglas-Peucker polyline simplification algorithm.
%
%  Input  :
%     polygons  : The polygons given in a three-column format [ ID, Latitude,
%                 Longitude ].
%     tolerance : The tolerance threshold (in meters) for simplifying
%                 building outlines.
%
%  Output :
%       simplPolygons: The simplified polygon.
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk

    tic
    % Initiate indices and counters
    startIndex = 1;
    endIndex=1;
    simplPolygonCounter = 1;

    % Preallocate the array to be the size of original polygon
    simplPolygons=zeros(size(polygons,1),3);

    % If tolerance for building simplification is not provided, there is no
    % simplification
    if nargin <= 2
        tolerance = 0;
    else
        tolerance = map.simplificationTolerance;
    end

    while endIndex<=length(polygons)   
        % Find the polygon to be simplified
        indices = find(polygons(startIndex,1)==polygons(:,1));
        simplifiedPolygon = polygons(indices, [2 3]);
        
        % Run the Douglas-Peucker polyline simplification algorithm
        if length(simplifiedPolygon)>4 && tolerance>0
            simplifiedPolygon = dpsimplify(simplifiedPolygon,tolerance);
        end

        % Add the current polygon to the array
        simplPolygons(simplPolygonCounter:simplPolygonCounter+...
            size(simplifiedPolygon,1)-1,:) = [repmat(polygons(startIndex,1),...
            size(simplifiedPolygon,1),1) simplifiedPolygon];
        simplPolygonCounter = simplPolygonCounter+length(simplifiedPolygon);
        endIndex = indices(end)+1;
        startIndex = endIndex;
    end
    % Remove extra rows
    simplPolygons=simplPolygons(simplPolygons(:,1)~=0,:);
    
    verbose('Simplifying and Removing inner polygons took %f seconds.',toc);
    
end
