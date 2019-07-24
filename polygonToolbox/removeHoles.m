function [ polygons ] = removeHoles( polygons )
%REMOVEHOLES This function removes the holes from all the polygons to 
%  simplify their shape. It uses only the polygons that contain a hole
%  (given by the NaNs in the building structure) to speed up the process.
%
%  Input  :
%       polygons : The polygons given in a three-column format [ ID,
%                  Latitude, Longitude ] (contains the holes to be removed).
%
%  Output :
%       polygons : The returned polygons (after all holes are removed).
%                   
% Copyright (c) 2018-2019, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk

    tic
    
    % Find all the unique IDs of the polygons that have a hole.
    uniqueIDs = unique(polygons(isnan(polygons(:,2)),1));
    
    % Iterate for all these polygons with a hole.
    for i = 1:length(uniqueIDs)
        % Find the rows with a specific ID inside the polygons structure
        % and format a polygon into a cell format.
        rows = find(uniqueIDs(i)==polygons(:,1));
        newPolygon = splitPolygons(polygons(rows,[2 3]));
        
        % For each polygon take the union of all individual polygons to
        % remove the holes - check if is clockwise
        for k = 2:length(newPolygon)
            if ~ispolycw(newPolygon{1}(:,1), newPolygon{1}(:,2))
                newPolygon{1}(:,1) = flipud(newPolygon{1}(:,1));
                newPolygon{1}(:,2) = flipud(newPolygon{1}(:,2));
            end
            [ x,y ] = polybool('union', newPolygon{k}(:,1), newPolygon{k}(:,2),...
                newPolygon{1}(:,1), newPolygon{1}(:,2));
            if ~isempty(x) && ~isempty(y)
                newPolygon{1} = [ x,y ];
            end
        end

        % Remove old polygon (with the holes) from the structure.
        polygons(rows,:) = [];
        % Add the new concatenated polygon at the end of the structure.
        polygons = [ polygons;...
            [ repmat(uniqueIDs(i),length(newPolygon{1}),1) newPolygon{1} ]];
    end

    verbose('Removing the polygons holes took %f seconds.', toc);
end



