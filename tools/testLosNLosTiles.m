function testLosNLosTiles(outputMap,tilePos,losTileIDs, nLosTileIDs,rssLosTile,...
    rssNLosTile,buildingIds,raysToTest,losLinks,nLosLinks)
%TESTLOSRSS Test the LOS and NLOS tile calculation and their association
% with the RSSI values.
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
% email: ioannis.mavromatis@toshiba-trel.com


    clf;
    figure(1)
    mapPrint(outputMap);
    alpha(0.1)
    hold on;
    for ll = 1:length(buildingIds)
        xBuildings = outputMap.buildings( ismember(outputMap.buildings(:,1), buildingIds(ll)), 3 );
        yBuildings = outputMap.buildings( ismember(outputMap.buildings(:,1) ,buildingIds(ll)), 2 );
        patch(xBuildings,yBuildings,'black')
        hold on
    end
    plot(tilePos(:,1), tilePos(:,2),'o','color',[1 0.4100 0.1700],'MarkerSize',20,'LineWidth',2)
    hold on;
%     plot(outputMap.inCentresTile(sortedIndicesTiles,1),outputMap.inCentresTile(sortedIndicesTiles,2),'b+','MarkerSize',10)
%     hold on;

    plot(outputMap.inCentresTile(losTileIDs,1), outputMap.inCentresTile(losTileIDs,2),'o','color',[0 0.8 0 ]);
    hold on;
    plot(outputMap.inCentresTile(nLosTileIDs,1), outputMap.inCentresTile(nLosTileIDs,2),'o','color',[1 0.1 0.9 ]);
    hold on;

    
    figure(2)
    mapPrint(outputMap);
    alpha(0.1)
    hold on;
    for ll = 1:length(buildingIds)
        xBuildings = outputMap.buildings( ismember(outputMap.buildings(:,1), buildingIds(ll)), 3 );
        yBuildings = outputMap.buildings( ismember(outputMap.buildings(:,1) ,buildingIds(ll)), 2 );
        patch(xBuildings,yBuildings,'black')
        hold on
    end
    
    color = jet(length(rssLosTile)+length(rssNLosTile));
    color = flipud(color);
    %                 x = [ raysToTest(:,1), raysToTest(:,3) ];
    %                 y = [ raysToTest(:,2), raysToTest(:,4) ];
    %                 h1 = line( x',y','LineStyle','-','Color',[ 0 1 0 ],'Marker','+')
    %                 hold on;
    counter = 1;
    x = [ raysToTest(losLinks,1), raysToTest(losLinks,3) ];
    y = [ raysToTest(losLinks,2), raysToTest(losLinks,4) ];
    for l = 1:length(rssLosTile)
        h1 = line(x(l,:),y(l,:),'LineStyle','-','LineWidth',2,'Color',[1 0 0],'Marker','*','MarkerSize',20);
        hold on
        h1.Color = color(counter,:);
        h1.MarkerFaceColor = color(counter,:);
        counter = counter + 1;
    end
    
    x = [ raysToTest(nLosLinks,1), raysToTest(nLosLinks,3) ];
    y = [ raysToTest(nLosLinks,2), raysToTest(nLosLinks,4) ];
    for l = 1:length(rssNLosTile)
        h2 = line(x(l,:),y(l,:),'LineStyle','-.','LineWidth',2,'Color',[1 0 0],'Marker','*','MarkerSize',20,'MarkerIndices',2);
        hold on
        h2.Color = color(counter,:);
        h2.MarkerFaceColor = color(counter,:);
        counter = counter + 1;
    end
end

