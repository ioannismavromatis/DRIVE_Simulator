function [ roads2 ] = roadsPolygon(roadsLine)
%ROADSPOLYGON Based on the parsed road line, given from the OSM file, the
%  road polygons are generated with respect to the road width and type.
%
%  Input  :
%       roadsLine : The road line generated from the OSM file.
%   
%  Output :
%       roads : The road polygons after the processing.
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk

    tic
    % Initialise the polygon coordinates.
    polygonX = zeros(0);
    polygonY = zeros(0);
    roads = zeros(0);

    % Iterate for all the line sectors parsed.
    for i=2:length(roadsLine)
        if(roadsLine(i,1)~=roadsLine(i-1,1))
            if ~ispolycw(polygonX,polygonY)
                [ polygonX,polygonY ] = poly2cw(polygonX,polygonY);
            end

            if ~isempty(roads)
                [x,y] = polybool('union',roads(:,2),roads(:,3),polygonX,polygonY);
                roads = [ repmat(roadsLine(i-1,1), length(x),1),...
                                        x, y ];
            else
                roads = [ roads; [ repmat(roadsLine(i-1,1), length(polygonX),1),...
                                       polygonX', polygonY' ] ];
            end
            polygonX = zeros(0);
            polygonY = zeros(0);
        else
            d = roadsLine(i,4)*3.2;
            angle = atan2d(roadsLine(i,3)-roadsLine(i-1,3),roadsLine(i,2)-roadsLine(i-1,2));

            angle = angle - 90;
            x21_one = roadsLine(i-1,2) + d*cosd(angle);
            y21_one = roadsLine(i-1,3) + d*sind(angle);

            x22_one = roadsLine(i,2) + d*cosd(angle);
            y22_one = roadsLine(i,3) + d*sind(angle);

            angle = angle + 180;
            x21_two = roadsLine(i-1,2) + d*cosd(angle);
            y21_two = roadsLine(i-1,3) + d*sind(angle);

            x22_two = roadsLine(i,2) + d*cosd(angle);
            y22_two = roadsLine(i,3) + d*sind(angle);

            angle = angle - 90;

            polygonXtemp = [ x21_two x22_two x22_one x21_one x21_two ];
            polygonYtemp = [ y21_two y22_two y22_one y21_one y21_two ];
            if ~ispolycw(polygonXtemp,polygonYtemp)
                [ polygonXtemp,polygonYtemp ] = poly2cw(polygonXtemp,polygonYtemp);
            end
            try
                [ polygonX, polygonY ] = polybool('union',polygonX,polygonY,polygonXtemp,polygonYtemp);
            end

            if i<length(roadsLine) && (roadsLine(i+1,1)==roadsLine(i,1))
                angleNext = atan2d(roadsLine(i+1,3)-roadsLine(i,3),roadsLine(i+1,2)-roadsLine(i,2));
                if angleNext>0 && angle>0
                    if angleNext > angle
                        x23 = roadsLine(i,2) + d*cosd(angleNext-90);
                        y23 = roadsLine(i,3) + d*sind(angleNext-90);
                        polygonXTriangle = [ roadsLine(i,2) x23 x22_one roadsLine(i,2) ];
                        polygonYTriangle = [ roadsLine(i,3) y23 y22_one roadsLine(i,3) ];
                    else
                        x23 = roadsLine(i,2) + d*cosd(angleNext+90);
                        y23 = roadsLine(i,3) + d*sind(angleNext+90);
                        polygonXTriangle = [ roadsLine(i,2) x22_two x23  roadsLine(i,2) ];
                        polygonYTriangle = [ roadsLine(i,3) y22_two y23  roadsLine(i,3) ];

                    end
                elseif angleNext<0 && angle<0
                    if angleNext > angle
                        x23 = roadsLine(i,2) + d*cosd(angleNext-90);
                        y23 = roadsLine(i,3) + d*sind(angleNext-90);
                        polygonXTriangle = [ roadsLine(i,2) x23 x22_one roadsLine(i,2) ];
                        polygonYTriangle = [ roadsLine(i,3) y23 y22_one roadsLine(i,3) ];
                    else
                        x23 = roadsLine(i,2) + d*cosd(angleNext+90);
                        y23 = roadsLine(i,3) + d*sind(angleNext+90);
                        polygonXTriangle = [ roadsLine(i,2) x22_two x23  roadsLine(i,2) ];
                        polygonYTriangle = [ roadsLine(i,3) y22_two y23  roadsLine(i,3) ];
                    end
                elseif (angleNext>0 && angle<0) || (angleNext<0 && angle>0)
                        x23 = roadsLine(i,2) + d*cosd(angleNext+90);
                        y23 = roadsLine(i,3) + d*sind(angleNext+90);
                        polygonXTriangle = [ roadsLine(i,2) x22_two x23  roadsLine(i,2) ];
                        polygonYTriangle = [ roadsLine(i,3) y22_two y23  roadsLine(i,3) ];
                else
                    polygonXTriangle = roadsLine(i,2);
                    polygonYTriangle = roadsLine(i,3);
                end

                if ~ispolycw(polygonXTriangle,polygonYTriangle)
                    [ polygonXTriangle,polygonYTriangle ] = poly2cw(polygonXTriangle,polygonYTriangle);
                end

                [ polygonX, polygonY ] = polybool('union',polygonX,polygonY,polygonXTriangle,polygonYTriangle);
            end          

        end
    end

    % Refine the map polygon (remove some blemishes from the previous
    % procedure)
    counter = 1;
    toRemove = [];
    for i = 1:length(roads)-2
        if ~isnan(roads(i,3)) && ~isnan(roads(i+1,3)) && ~isnan(roads(i+2,3))
            if abs(roads(i,3)-roads(i+2,3))<=3 && abs(roads(i,2)-roads(i+2,2))<=3
                if abs(roads(i,3)-roads(i+1,3))>3 && abs(roads(i,2)-roads(i+1,2))>3
                    toRemove(counter) = i;
                    counter = counter + 1;
                    toRemove(counter) = i+1;
                    counter = counter + 1;
                end
            end
        end
    end
    roads2 = roads;
    if ~isempty(toRemove)
        roads2(toRemove,:)=[];
    end

    % For test purposes - Plot the polygons
    % clf
    % plot(roads(:,3),roads(:,2),'b-')
    % hold on
    % plot(roads2(:,3),roads2(:,2),'mo')
    % 
    % pos = find(roads(:,3)>1740 & roads(:,3)<1742);
    % idx = find(roads(pos,2)>1193 & roads(pos,2)<1195);
    % pos = pos(idx);

    verbose('Generating the road polygons took %f seconds.', toc);
end


