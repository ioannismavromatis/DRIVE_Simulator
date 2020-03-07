function testMapPlot(output,shape, buildingsIn)
%testMapPlot This is a function to test the validity of the scripts
%  designed for the different polygon shapes. It plots a figure showing the
%  initial map, the incentres from the tiles/areas, the vertices of the
%  tiles/areas, and finally the buildings that are withing the areas of the
%  map (this is optional and only when the map areas are calculated).
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
% email: ioannis.mavromatis@toshiba-bril.com
    clf
    mapPrint(output)
    alpha(0.5)
    hold on  
    
    if strcmp(shape,'area')
        plot(output.inCentresArea(:,1),output.inCentresArea(:,2), 'ro')
        hold on
        if isfield(output,'pHandleArea')
            for i = 1:length(output.pHandleArea)
                idx = output.pHandleArea{i};
                idx = [ idx idx(1) ];
                plot(output.vHandleArea(idx,1), output.vHandleArea(idx,2),'LineWidth',6,'color',[0 0 1])
                hold on
            end
        else
            [toRun,~] = size(output.areaVerticesX);
            for i = 1:toRun
                plot(output.areaVerticesX(i,:),output.areaVerticesY(i,:),'LineWidth',6,'color',[0 0 1])
                hold on
            end
        end
    else
        plot(output.inCentresTile(:,1),output.inCentresTile(:,2), 'ro')
        hold on
        [toRun,~] = size(output.tileVerticesX);
        for i = 1:toRun
            plot(output.tileVerticesX(i,:),output.tileVerticesY(i,:),'LineWidth',2,'color',rand(1,3))
            hold on
        end
    end
    
    if strcmp(shape,'area')
        buildings = testPolygonPlot(output.buildingsIn);
        hold on
        mapshow(buildings(:,3),buildings(:,2),'DisplayType','polygon','FaceColor',[0 0.6 0],'LineStyle',':') % plot the map parsed from SUMO network file
    end
end

