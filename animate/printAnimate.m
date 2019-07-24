function printAnimate(sumo,vehicle,pedestrian,outputMap)
%PRINTANIMATE This function interpolates the vehicle and pedestrian
%  positions at first, plots the map in a figure and prints all the mobility
%  traces overlaid above the map. The mobility traces are update per
%  timestep interval.
%
%  Input  :
%     vehicle     : A structure containing all the information about the
%                   vehicles (type, position at each timeslot, etc.)
%     pedestrian  : A structure containing all the information about the
%                   pedestrians (type, position at each timeslot, etc.)
%     outputMap   : The map structure extracted from the map file or loaded
%                   from the preprocessed folder
%
% Copyright (c) 2018-2019, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk    

    global SIMULATOR
    
    if SIMULATOR.map == 0
        mapPrint(outputMap);
        return
    end
    
    timeSteps = 0:vehicle.simStep:vehicle.simTime;
    
    % The linear position interpolation
    vNode = positionInterpolation(vehicle);
    pNode = positionInterpolation(pedestrian);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    clf
    mapPrint(outputMap);
    alpha(0.5)
    
    hold on;
    % Generate the animation of the different links for all vehicles and
    % pedestrians
    [vNodePos,typePos] = generateLineObjects(vNode,vehicle);
    pNodePos = generateLineObjects(pNode,pedestrian);
    
    % The information of the matlab figure
    title('5G V2X AI-Assisted Simulation Framework')
    xlabel('X (meters)');
    ylabel('Y (meters)');
    axlim = get(gca, 'XLim');    % Get XLim Vector
    aylim = get(gca, 'YLim');    % Get YLim Vector 
    x_txt = min(axlim) + 120;    % Set x-Coordinate Of Text Object
    y_txt = max(aylim) + 20;     % Set y-Coordinate Of Text Object
    ht = text(x_txt, y_txt, cat(2,'Time (sec) = 0'));

    legendString = {};
    for i = 1:length(vehicle.type)
        legendString{i} = sumo.vehicleTypes{vehicle.type(i)};
    end
    legendString{i+1} = 'Pedestrian';
    legend(legendString,'Location','eastoutside')
   
    % Update all the vehicle and pedestrian positions per timeslot
    hold off;
    for timeIndex = 1:length(timeSteps)-1
        t = timeSteps(timeIndex);
        set(ht,'String',cat(2,'Time (sec) = ',num2str(t,4)));
        if ~isempty(fieldnames(vehicle))
            for nodeIndex = 1:length(vehicle.vehNode)
                set(vNodePos(nodeIndex),'XData',vNode(nodeIndex).v_x(timeIndex),'YData',vNode(nodeIndex).v_y(timeIndex));
            end
        end
        
        if ~isempty(fieldnames(pedestrian))
            for nodeIndex = 1:length(pedestrian.pedNode)
                set(pNodePos(nodeIndex),'XData',pNode(nodeIndex).v_x(timeIndex),'YData',pNode(nodeIndex).v_y(timeIndex));
            end
        end
        
        drawnow;
%         pause(0.02);
    end
end
