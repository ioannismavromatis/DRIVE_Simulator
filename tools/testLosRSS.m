function testLosRSS(outputMap,pos,rssTile,raysToTest,losLinks,buildingIds,sortedIndicesTiles)
%TESTLOSRSS Summary of this function goes here
%   Detailed explanation goes here
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
% email: ioannis.mavromatis@toshiba-bril.com
    clf;
    mapPrint(outputMap);
    alpha(0.1)
    hold on;
    for ll = 1:length(buildingIds)
        xBuildings = outputMap.buildings( ismember(outputMap.buildings(:,1), buildingIds(ll)), 3 );
        yBuildings = outputMap.buildings( ismember(outputMap.buildings(:,1) ,buildingIds(ll)), 2 );
        patch(xBuildings,yBuildings,'black')
        hold on
    end
    plot(pos(:,2), pos(:,1),'o','color',[1 0.4100 0.1700],'MarkerSize',20,'LineWidth',2)
    hold on;
%     plot(outputMap.inCentresTile(sortedIndicesTiles,1),outputMap.inCentresTile(sortedIndicesTiles,2),'b+','MarkerSize',10)
%     hold on;

    color = jet(length(rssTile));
    color = flipud(color);
    %                 x = [ raysToTest(:,1), raysToTest(:,3) ];
    %                 y = [ raysToTest(:,2), raysToTest(:,4) ];
    %                 h1 = line( x',y','LineStyle','-','Color',[ 0 1 0 ],'Marker','+')
    %                 hold on;
    x = [ raysToTest(losLinks,1), raysToTest(losLinks,3) ];
    y = [ raysToTest(losLinks,2), raysToTest(losLinks,4) ];
    for l = 1:length(color)
        h1 = line(x(l,:),y(l,:),'LineStyle','-','Color',[1 0 0],'Marker','*','MarkerSize',20);
        hold on
        h1.Color = color(l,:);
        h1.MarkerFaceColor = color(l,:);
    end
end

