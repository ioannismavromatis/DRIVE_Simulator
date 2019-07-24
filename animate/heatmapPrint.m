function heatmapPrint(outputMap,map,highestRSSValue,chosenBSpos,potBSPos,tilesID)
%HEATMAPPRINT This function prints a heatmap for the given map and using
%  the given received signal strength values from all the chose
%  basestations around the city. Later, the layout of the building is
%  printed as well.
%
%  Input  :
%     outputMap       : The map structure extracted from the map file or
%                       loaded from the preprocessed folder
%     map             : Structure containing all map settings (filename,
%                       path, simplification tolerance to be used, etc).
%     highestRSSValue : Structure that contains the highest RSS values for
%                       any given tile on the map.
%     chosenBSpos     : The IDs of the chosen basestations (to be used with
%                       the entire list of basestations).
%     potBSPos        : The positions of all the potential basestations
%                       around the map.
%     tilesID         : The IDs of the tiles to fill with color, when the
%                       heatmap is plotted
%
% Copyright (c) 2018-2019, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk

    clf
    mapPrint(outputMap);
    alpha(0.5)
    hold on;

    if map.tileShape == 1
        [x,y] = unique(tilesID);
        %
        %  TO BE FIXED LATER
        %
        % Plot the heatmap for hexagon tiles
        tileCounter = 1;
        plotCounter = 0;
        for i = 1:numel(outputMap.pHandle)
            if all(outputMap.pHandle{i}~=1) && length(outputMap.pHandle{i}) == 6 && outputMap.validIncentresIDs(i)
                if ismember(tileCounter,x)
                    plotCounter = plotCounter + 1;
                    patch(outputMap.vHandle(outputMap.pHandle{i},1), ...
                        outputMap.vHandle(outputMap.pHandle{i},2),highestRSSValue(y(plotCounter)),'LineStyle','none'); 
                end
                tileCounter = tileCounter + 1;
            end
        end
    else
        % Plot the heatmap for square tiles
        % Generate the tile coordinates from the incentres    
        rectanglesX = [ outputMap.inCentresTile(:,1)-map.tileSize/2 ... 
                        outputMap.inCentresTile(:,1)+map.tileSize/2 ... 
                        outputMap.inCentresTile(:,1)+map.tileSize/2 ... 
                        outputMap.inCentresTile(:,1)-map.tileSize/2 ... 
                        outputMap.inCentresTile(:,1)-map.tileSize/2 ];

        rectanglesY = [ outputMap.inCentresTile(:,2)+map.tileSize/2 ...
                        outputMap.inCentresTile(:,2)+map.tileSize/2 ...
                        outputMap.inCentresTile(:,2)-map.tileSize/2 ...
                        outputMap.inCentresTile(:,2)-map.tileSize/2 ...
                        outputMap.inCentresTile(:,2)+map.tileSize/2 ];

        patch(rectanglesX(tilesID,:)', rectanglesY(tilesID,:)',highestRSSValue,'LineStyle','none')                
    end
    
    colorbar;
    
    hold on;
    % Plot the position of the basestations
    plot(potBSPos(chosenBSpos,2), potBSPos(chosenBSpos,1),...
         'o','color',[0 0 0],'MarkerSize',20,'LineWidth',3)
    hold on

    % Update the limits of the figure given the edge coordinates of the buildings
    minX = min(outputMap.buildingsAnimation(:,3));
    minY = min(outputMap.buildingsAnimation(:,2));
    maxX = max(outputMap.buildingsAnimation(:,3));
    maxY = max(outputMap.buildingsAnimation(:,2));
    xlim([minX maxX]);
    ylim([minY maxY]);
end

