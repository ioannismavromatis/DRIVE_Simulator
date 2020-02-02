function mapPrint( outputMap, potRSUPos )
%mapPrint Function to print the parsed map and the positions of the RSUs
% The positions of the RSUs is optional and the map can be printed without
% that. The different polygons are plotted on the map with different
% colours, i.e. red for buildingsAnimation, green for parks, black for roads.
%
%  Input  :
%     outputMap  : The map structure extracted from the map and modified
%                  afterwards.
%     potRSUPos  : If the potential positions are provided when the
%                  function is called, they will be printed on top of the map.
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
% email: ioannis.mavromatis@toshiba-trel.com

%     changeIndexes = diff(outputMap.roadsLine(:,1))~=0;
%     changeIndexes = [ 0 ; changeIndexes ];
%     changeIdxRoadsLineNew = find(changeIndexes == 1);
%     matrix = [0:length(changeIdxRoadsLineNew)-1]';
%     changeIdxRoadsLineNew = changeIdxRoadsLineNew+matrix;
% 
%     [r,c]       = size(outputMap.roadsLine);
%     add         = numel(changeIdxRoadsLineNew);            % How much longer Anew is
%     roadsLineNew = NaN(r + add,c);        % Preallocate
%     idx         = setdiff(1:r+add,changeIdxRoadsLineNew);  % all positions of Anew except pos
%     roadsLineNew(idx,:) = outputMap.roadsLine;


    if ~isempty(outputMap.buildingsAnimation)
        changeIndexes = diff(outputMap.buildingsAnimation(:,1))~=0;
        changeIndexes = [ 0 ; changeIndexes ];
        changeIdxBuildings = find(changeIndexes == 1);
        matrix = [0:length(changeIdxBuildings)-1]';
        changeIdxBuildings = changeIdxBuildings+matrix;

        [r,c]       = size(outputMap.buildingsAnimation);
        add         = numel(changeIdxBuildings);            % How much longer Anew is
        buildingsNew = NaN(r + add,c);        % Preallocate
        idx         = setdiff(1:r+add,changeIdxBuildings);  % all positions of Anew except pos
        buildingsNew(idx,:) = outputMap.buildingsAnimation;
    end

    if ~isempty(outputMap.foliageAnimation)
        changeIndexes = diff(outputMap.foliageAnimation(:,1))~=0;
        changeIndexes = [ 0 ; changeIndexes ];
        changeIdxFoliage = find(changeIndexes == 1);
        matrix = [0:length(changeIdxFoliage)-1]';
        changeIdxFoliage = changeIdxFoliage+matrix;

        [r,c]       = size(outputMap.foliageAnimation);
        add         = numel(changeIdxFoliage);            % How much longer Anew is
        foliageNew = NaN(r + add,c);        % Preallocate
        idx         = setdiff(1:r+add,changeIdxFoliage);  % all positions of Anew except pos
        foliageNew(idx,:) = outputMap.foliageAnimation;
    end

    set(gcf, 'Position', get(0, 'Screensize'));
    
    if ~isempty(outputMap.buildingsAnimation)
        obj = mapshow(buildingsNew(:,3),buildingsNew(:,2),'DisplayType','polygon','FaceColor',[1 0 0],'LineStyle',':'); % plot the map parsed from SUMO network file;
        set(get(get(obj,'Annotation'),'LegendInformation'),'IconDisplayStyle','off')
        hold on;
    end
%     mapshow(roadsLineNew(:,3),roadsLineNew(:,2),'DisplayType','line','LineStyle','-') % plot the map parsed from SUMO network file
    hold on
    if ~isempty(outputMap.foliageAnimation)
        obj = mapshow(foliageNew(:,3),foliageNew(:,2),'DisplayType','polygon','FaceColor',[0 1 0],'LineStyle','none'); % plot the map parsed from SUMO network file
        set(get(get(obj,'Annotation'),'LegendInformation'),'IconDisplayStyle','off')
        hold on
    end
%     obj = mapshow(outputMap.roadsPolygons(:,3),outputMap.roadsPolygons(:,2),'DisplayType','polygon','FaceColor',[0 0 0],'LineStyle','none'); % plot the map parsed from SUMO network file
%     set(get(get(obj,'Annotation'),'LegendInformation'),'IconDisplayStyle','off')
%     hold on
%     obj = plot(outputMap.trafficLights(1,:),outputMap.trafficLights(2,:),'*','Markersize',5);
%     set(get(get(obj,'Annotation'),'LegendInformation'),'IconDisplayStyle','off')
%     hold on
    

    minX = min(outputMap.buildingsAnimation(:,3));
    minY = min(outputMap.buildingsAnimation(:,2));
    maxX = max(outputMap.buildingsAnimation(:,3));
    maxY = max(outputMap.buildingsAnimation(:,2));
    xlim([minX maxX]);
    ylim([minY maxY]);
    drawnow;
    
    if nargin>1
        plot(potRSUPos(:,2),potRSUPos(:,1),'x','MarkerSize',8,'MarkerEdgeColor',[0.9451,0.5804,0.2588]);
    end
end

