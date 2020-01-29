function polygons = mergePolygons(polygons)
% MERGEPOLYGONS This function merges the tangentially polygons (that
% share one side - edge).
%  This can simplify the polygon structure speeding up the calculations
%  later - e.g. for the propagation loss calculation.
%
%  Input  :
%     polygons : The polygons given in a three-column format [ ID, Latitude,
%                Longitude ].
%
%  Output :
%     polygons : The merged polygons after the processing.
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk

    tic

    % Remove the wrap-around rows of the polygons.
    [ polygonsUniqueRows, ~ ] = unique(polygons, 'rows');

    % Find all the unique coordinates of the polygons.
    [ ~, polyUniqueCoordIndices ] = unique(polygonsUniqueRows(:,[2 3]),'rows');
    
    % Find the duplicate latitude and longitude rows in the polygon list.
    % Find the non-repeating rows at first.
    duplicateRows = setdiff(polygonsUniqueRows,...
        polygonsUniqueRows(polyUniqueCoordIndices,:),'rows','sorted');
    [ ~, nonRepRowsIndices ] = setdiff(polygonsUniqueRows(:,[2 3]),...
        duplicateRows(:,[2 3]),'rows','sorted');
    
    % Find the duplicates later based on the above.
    duplicateRows = polygonsUniqueRows(setdiff(1:size(polygonsUniqueRows,1),...
        nonRepRowsIndices,'sorted'),:);

    % Iterate for all the duplicate rows found before
    while ~isempty(duplicateRows)
        % Get all the rows with the same latitude and longitude as the
        % current one
        tmp = ismember(duplicateRows(:,[2 3]),duplicateRows(1,[2 3]));
        sameRowsIDs = duplicateRows(tmp(tmp(:,1)~=0),:);
       
        % Get the IDs of rows to be merged
        tmp = ismember(polygons(:,[2 3]),duplicateRows(1,[2 3]));
        getPolygonsToMerge = polygons(tmp(:,1)~=0,1);
      
        % Get the unique rows to be merged
        getPolygonsToMerge = polygons(ismember(polygons(:,1),getPolygonsToMerge),:);
        uniqueIDs = unique(getPolygonsToMerge(:,1));
        
        % Initialise the new polygon
        newlyMergedPolygon = zeros(0);

        % Union over the polygons in sameRowsIDs
        if numel(uniqueIDs)>1
            for i=1:numel(uniqueIDs)-1
                if i==1
                    % Get current's polygon X and Y coordinates in clockwise vertex ordering 
                    [ currPolygonX, currPolygonY ] = poly2cw...
                        (getPolygonsToMerge(getPolygonsToMerge(:,1)==uniqueIDs(i),2),...
                        getPolygonsToMerge(getPolygonsToMerge(:,1)==uniqueIDs(i),3));
                else
                    if isempty(newlyMergedPolygon)
                        currPolygonX = [];
                        currPolygonY = [];
                    else                    
                        currPolygonX = newlyMergedPolygon(:,1);
                        currPolygonY = newlyMergedPolygon(:,2);
                    end
                end
                % Get next polygon's X and Y coordinates in clockwise vertex ordering          
                [ nextPolygonX, nextPolygonY ] = poly2cw...
                    (getPolygonsToMerge(getPolygonsToMerge(:,1)==uniqueIDs(i+1),2),...
                    getPolygonsToMerge(getPolygonsToMerge(:,1)==uniqueIDs(i+1),3));
                % Get the union of polygons (merge new and next building)
                [ newPolygonX, newPolygonY ] = polybool('union',currPolygonX,...
                    currPolygonY,nextPolygonX,nextPolygonY);
                newlyMergedPolygon = [newPolygonX newPolygonY];
            end
            % Add the the new polygon ID, remove the merged polygons and
            % add the newly created one
            newlyMergedPolygon = ...
                [repmat(sameRowsIDs(1,1),size(newlyMergedPolygon,1),1)...
                newlyMergedPolygon];

            polygons(ismember(polygons(:,1),getPolygonsToMerge),:) = [];
            polygons = [polygons; newlyMergedPolygon];

        end
        % Remove the rows in sameLatLonRowIDs from duplicateRows
        tmp = ismember(duplicateRows(:,[2 3]),duplicateRows(1,[2 3]));
        duplicateRows(find(tmp(:,1)~=0),:) = [];
    end
    
    verbose('The merging of the buildings polygons took %f seconds.', toc);
    
end
