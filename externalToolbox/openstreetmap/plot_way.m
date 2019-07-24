function [ buildings, foliage, roadsLine, trafficLights ] = plot_way(ax, parsed_osm,map_img_filename)
%PLOT_WAY   plot parsed OpenStreetMap file
%
% usage
%   PLOT_WAY(ax, parsed_osm)
%
% input
%   ax = axes object handle
%   parsed_osm = parsed OpenStreetMap (.osm) XML file,
%                as returned by function parse_openstreetmap
%   map_img_filename = map image filename to load and plot under the
%                      transportation network
%                    = string (optional)
%
% See also PARSE_OPENSTREETMAP, EXTRACT_CONNECTIVITY.
%
% File:         plot_way.m
% Author:       Ioannis Filippidis, jfilippidis@gmail.com
% Date:         2010.11.06 - 2012.04.17
% Language:     MATLAB R2012a
% Purpose:      plot parsed OpenStreetMap file
% Copyright:    Ioannis Filippidis, 2010-

% Modified by:  2018-2019, Ioannis Mavromatis

tic
if nargin < 5
    map_img_filename = [];
end

[bounds, node, way, ~] = assign_from_parsed(parsed_osm);

disp_info(bounds, node, size(way.id, 2))

[buildings, foliage, roadsLine, trafficLights]=show_ways(ax, bounds, node, way, map_img_filename);

verbose('Generating the buildings (polygons), foliage (polygons) and the roadline took %f seconds.', toc);
close all;

function [buildings, foliage, roadsLine, trafficLights] = show_ways(~, ~, node, way, ~)

% externalFunc.openstreetmap.show_map(hax, bounds, map_img_filename)

buildings = zeros(0);
foliage = zeros(0);
roadsLine = zeros(0);

key_catalog = {};
for i=1:size(way.id, 2)
    [key, val] = get_way_tag_key(way.tag{1,i} );    
    % Find unique way types
    if isempty(key)
    elseif isempty( find(ismember(key_catalog, key) == 1, 1) )
        key_catalog(1, end+1) = {key};
    end
        
    flag = 0;
    switch key
        case {'building','shop','amenity'}
            flag = 1;
        case 'landuse'
            if strcmp(val, 'forest') || strcmp(val, 'residential')
                flag = 2;
            end
        case {'natural','leisure'}
            if strcmp(val, 'wood') || strcmp(val, 'tree') || strcmp(val, 'tree_row') || strcmp(val, 'peak') ||  strcmp(val, 'park')
                flag = 3;
            end
        case 'highway'
            if strcmp(val, 'primary') || strcmp(val, 'secondary') || strcmp(val, 'residential') || strcmp(val, 'unclassified') || strcmp(val, 'tertiary')
                flag = 4;
                if strcmp(val, 'primary')
                    lanes = 4;
                elseif strcmp(val, 'secondary')
                    lanes = 3;
                elseif strcmp(val, 'residential')
                    lanes = 2;
                elseif strcmp(val, 'unclassified')
                    lanes = 2;
                elseif strcmp(val, 'tertiary')
                    lanes = 2;
                end
            elseif strcmp(val, 'traffic_signals') 
                fprintf('This is a traffic light')
            end
        otherwise
%             disp('way without tag.')
    end
    
    % Find traffic lights
    trafficLights = node.xy(:,logical(node.trafficLights));
    
    % Plot roads
    way_nd_ids = way.nd{1, i};
    num_nd = size(way_nd_ids, 2);
    nd_coor = zeros(2, num_nd);
    nd_ids = node.id;
    % Mod: nodes that form a way might not exist in the node list
    emptyNodeFlag=0;
    for j=1:num_nd
        cur_nd_id = way_nd_ids(1, j);
        nodeXY=node.xy(:, cur_nd_id == nd_ids);
        if ~isempty(nodeXY)
            nd_coor(:, j) = node.xy(:, cur_nd_id == nd_ids);
        else
            nd_coor(:, j) = -Inf;
            emptyNodeFlag=1;
        end
    end
    
    if emptyNodeFlag
        empty_nds = nd_coor(1,:)==-Inf;
        nd_coor(:,empty_nds)=[];
        num_nd = num_nd-sum(empty_nds);
    end
    
    if num_nd>0
        if flag == 1
            buildings = [buildings; [repmat(way.id(i), num_nd, 1), ...
                nd_coor(2,:)', nd_coor(1,:)']];
        elseif flag == 2 || flag == 3
            foliage = [foliage; [repmat(way.id(i), num_nd, 1), ...
                nd_coor(2,:)', nd_coor(1,:)']];
        elseif flag == 4
            roadsLine = [roadsLine; [repmat(way.id(i), num_nd, 1), ...
                nd_coor(2,:)', nd_coor(1,:)', repmat(lanes, num_nd, 1)]];
        end
    end
end
disp('The different structures found in the map are the following:')
disp(key_catalog.')


function [] = disp_info(bounds, node, Nway)
disp( ['Bounds: xmin = ' num2str(bounds(1,1)),...
    ', xmax = ', num2str(bounds(1,2)),...
    ', ymin = ', num2str(bounds(2,1)),...
    ', ymax = ', num2str(bounds(2,2)) ] )
disp( ['Number of nodes: ' num2str(size(node.id, 2))] )
disp( ['Number of ways: ' num2str(Nway)] )
disp( ['Number of traffic lights: ' num2str(sum(node.trafficLights))] )


    
