function [ buildings, foliage, roads, trafficLights, bounds ] = cartesianAxisAlign( buildings, foliage, roads, trafficLights )
%cartesianAxisAlign Convert Lat/Lon coordinates to Cartesian and centre map
%with respect to the beginning of the axis ~ [0,0].
%  Finding the maximum and minimum longitude and latitude after the
%  coordinates are converted to Cartesian, the map is centred so it begins
%  from the beginning of the axis ~ [0,0].
%
%  Input:
%     buildings : The buildings polygons generated from the OSM file.
%     foliage   : The foliage polygons generated from the OSM file.
%     roads     : The foliage line generated from the OSM file.
%   
%  Output:
%     buildings : The buildings polygons after the processing.
%     foliage   : The foliage polygons after the processing.
%     roads     : The foliage line after the processing.
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
% email: ioannis.mavromatis@toshiba-trel.com

    % Process the buildings polygon
    [xxB,yyB,minXBuildings,minYBuildings,maxXBuildings,maxYBuildings,~] =...
             deg2utm(buildings(:,2),buildings(:,3));
    buildings(:,2) = yyB;
    buildings(:,3) = xxB; 
    
    % Process the positions of traffic lights line
    [xxB,yyB,minXTrafficLights,minYTrafficLights,maxXTrafficLights,maxYTrafficLights,~] =...
            deg2utm(trafficLights(2,:),trafficLights(1,:));
    trafficLights(2,:) = yyB;
    trafficLights(1,:) = xxB;

    % Process the roads line    
    [xxB,yyB,minXRoads,minYRoads,maxXRoads,maxYRoads,~] =...
             deg2utm(roads(:,2),roads(:,3));
    roads(:,2) = yyB;
    roads(:,3) = xxB;
    
    % Process the foliage polygon
    [xxB,yyB,minXFoliage,minYFoliage,maxXFoliage,maxYFoliage,~] =...
             deg2utm(foliage(:,2),foliage(:,3));
    foliage(:,2) = yyB;
    foliage(:,3) = xxB;

    % Find the minimum and maximum X and Y values from the Cartesian coordinates.
    minXAll = min(minXBuildings,minXRoads);
    minXAll = min(minXAll,minXFoliage);
    
    minYAll = min(minYBuildings,minYRoads);
    minYAll = min(minYAll,minYFoliage);
    
%     % Adjust the map according to the minimum values.
%     buildings(:,3) = buildings(:,3)- minXAll;
%     foliage(:,3) = foliage(:,3)- minXAll;
%     roads(:,3) = roads(:,3)- minXAll;
% 
%     buildings(:,2) = buildings(:,2)- minYAll;
%     foliage(:,2) = foliage(:,2)- minYAll;
%     roads(:,2) = roads(:,2)- minYAll;
    
    % Find the minimum and maximum X and Y values from the Cartesian coordinates.
    minXAll = min(minXBuildings,minXRoads);
    minXAll = min(minXAll,minXFoliage);
    minYAll = min(minYBuildings,minYRoads);
    minYAll = min(minYAll,minYFoliage);
    maxXAll = max(maxXBuildings,maxXRoads);
    maxXAll = max(maxXAll,maxXFoliage);
    maxYAll = max(maxYBuildings,maxYRoads);
    maxYAll = max(maxYAll,maxYFoliage);
    
    bounds = [ minXAll, maxXAll ;
               minYAll, maxYAll ];

end

