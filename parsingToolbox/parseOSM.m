function outputMap = parseOSM( map )
%PARSESUMOOSM This function parses an OSM map file downloaded from
%  Openstreetmaps and generates the necessary polygon structures.
%
%  Input  :
%     map       : The filename and the path of the map file to be processed
%                 or loaded.
%   
%  Output :
%     outputMap : The map structure used by the simulator
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
% email: ioannis.mavromatis@toshiba-bril.com

    tic
    % Parse Openstreetmap file and create Matlab structure
    [ parsedOSM, ~ ] = parse_openstreetmap(map.fileCorrectName);

    % Parse buildings, foliage and the roads from structure
    [ buildings, foliage, roadsLine, trafficLights ] = plot_way(axes,parsedOSM);

    % Convert Lat/Lon coordinates to Cartesian and centre map with respect to
    % the beginning of the axis ~ [0,0].
    [ buildings, foliage, roadsLine, trafficLights, ~ ] = ...
              cartesianAxisAlign( buildings, foliage, roadsLine, trafficLights );
    
    % Generate the road polygons based on the road line parsed from the OSM file
    if ~isempty(roadsLine)
        roads = roadsPolygon(roadsLine);
    end
    
    % Merge adjacent buildings(e.g. backyards)
    if ~isempty(buildings)
        buildingsMerged = mergePolygons(buildings);
    end
    % Merge adjacent foliage (e.g. parks)
    if ~isempty(foliage)
        foliageMerged = mergePolygons(foliage);
    end
    
    % Simplify the buildings polygons - this will reduce the number of
    % polygon edges - thus faster calculations later.
    buildingsMerged = simplifyPolygons(buildingsMerged,map);
    
    % Remove the inner holes of the buildings polygons - this simplifies
    % further the polygons.
    buildingsMerged = removeHoles(buildingsMerged);
    
    % Fix the polygons with NaNs
    buildingsMerged = fixNaNs(buildingsMerged);
    
    % Randomise the building height between 15 and 50m
    buildingsMerged = add3rdDimension(buildingsMerged);
    
    % Find the nodes and edges, i.e. the different building corners that
    % are connected and form the different buildings.
    [ nodes, edges ] = findNodesEdges(buildingsMerged);
    
    % Return the values within a structure in the upper function.
    outputMap.buildings = buildingsMerged;
    outputMap.buildingsAnimation = buildings;
    outputMap.edges = edges;
    outputMap.nodes = nodes;
    outputMap.foliage = foliageMerged;
    outputMap.foliageAnimation = foliage;
    outputMap.trafficLights = trafficLights;
    outputMap.roadsPolygons = roads;
    outputMap.roadsLine = roadsLine;
    outputMap.simplTolerance = map.simplificationTolerance;
    tmp = strsplit(map.fileCorrectName,'/');
    tmp = strsplit(tmp{end},'.');
    outputMap.name = tmp{1};
    
    % Calculate the bounds finding the minimum/maximum x and y from the
    % polygons parsed from OSM
    minX = min(min(buildings(:,2)),min(foliage(:,2)));
    minY = min(min(buildings(:,3)),min(foliage(:,3)));
    maxX = max(max(buildings(:,2)),max(foliage(:,2)));
    maxY = max(max(buildings(:,3)),max(foliage(:,3)));
    bounds = [ minX, maxX ; minY, maxY ];
    
    outputMap.bbox = bounds;

    verbose('Parsing the map required in total %f seconds.', toc);
    % Print the map
    printMap = readYesNo('Do you want to print the map now?','Y');
    if printMap
        mapPrint( outputMap );
    end
    
end

