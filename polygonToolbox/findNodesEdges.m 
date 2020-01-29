function [ nodes, edges ] = findNodesEdges(polygon)
%findNodesEdges Each polygon is shown with the nodes (being all the vertices of
%  the polygon) and the edges (being the pair connenctions of the nodes).
%  This function calculates the different pair of nodes being connected
%  with each other and the edges that represent the pairs.
%
%  Input  :
%     polygon : The polygon that needs to be parsed.
%   
%  Output :
%     nodes   : The vertices of the given polygon.
%     edges   : The pair connenctions of the given nodes.
%
% Copyright (c) 2018-2019, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk

    [~,idx]=unique(polygon(:,1),'stable');
    toRemove = idx(2:end)-1;
    polygon(toRemove,:) = [];
    nodes = polygon;
    
    uniqueIDs = unique(polygon(:,1),'stable');
    edges = zeros(length(polygon),2);
    
    for i = 1:length(uniqueIDs)
        idx = find(uniqueIDs(i) == polygon(:,1));
        edges(idx,:) = [ idx(1:end) [idx(2:end); idx(1)] ];
    end
end

