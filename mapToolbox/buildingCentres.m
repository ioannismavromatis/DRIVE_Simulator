function outputMap = buildingCentres(outputMap)
%BUILDINGCENTRES Calculate the incentre of the buildings using Delaunay 
%  Triangulation. Find in which area its building belongs (using the
%  incentres for that).
%
%  Input  :
%     outputMap : The map structure extracted from the map file or loaded
%                 from the preprocessed folder
%
%  Output :
%     outputMap : The map structure with the building incentres.
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk

    % Deactivate the warning from delaunay triangulation to avoid flooding
    % the command prompt
    warning('off','MATLAB:delaunayTriangulation:DupPtsWarnId');
    
    % Fin the incentre of the given buildings using Delaunay Triangulation
    uniqueBuildings = unique(outputMap.buildings(:,1));
    for i = 1:length(uniqueBuildings)
        building = outputMap.buildings(outputMap.buildings(:,1)==uniqueBuildings(i),:);
        TR = delaunayTriangulation(building(:,2),building(:,3));
        c = incenter(TR);
        buildingIncentre(i,:) = [ uniqueBuildings(i) mean(c,1) building(1,4) ];
    end
    outputMap.buildingIncentre = buildingIncentre;
    
    % Find the area that each building belongs to.
    [toRun,~] = size(outputMap.areaVerticesX);
    buildingsInArea = [];
    for i = 1 : toRun
        tmp=inpolygon(outputMap.buildingIncentre(:,3),outputMap.buildingIncentre(:,2),outputMap.areaVerticesX(i,:),outputMap.areaVerticesY(i,:));
        buildingIDs = outputMap.buildingIncentre(tmp,1);
        buildingsInArea = [ buildingsInArea ; buildingIDs repmat(i,[length(buildingIDs) 1]) ];
        buildingsInAreaLogicalIdx(:,i) = tmp;
    end
    outputMap.buildingsInArea = buildingsInArea;
    outputMap.buildingsInAreaLogicalIdx = buildingsInAreaLogicalIdx;
end

