function [obj,typePos] = generateLineObjects(node,structure)
%GENERATELINEOBJECTS This function is used to generate the animation of the
%  different links on the entire city map (for both vehicles and pedestrians)
%  It is used by the printAnimate function later.
%
%  Input  :
%     node      : A structure with the interpolated positions for the
%                 vehicles/pedestrians.
%     structure : A structure containing all the information about the
%                 vehicles/pedestrians (type, position at each timeslot, etc.)
%  Output :
%     obj       : An object containing the information about the vehicle/
%                 pedestrian (it will be later updated when the vehicle's/
%                 pedestrian's position is changed).
%     typePos   : The type of the vehicle.
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
% email: ioannis.mavromatis@toshiba-bril.com
    
    if isempty(fieldnames(structure))
        obj = [];
        typePos = [];
        return
    end

    if isfield(structure, 'vehNode')
        % for the different types of vehicles, pick a random color to
        % represent their type.
        colours = generateColours(structure);
        markers = [ 'o' ; 'd' ; 'h' ];
        typePos = zeros(1,length(structure.type));
        
        % generate all the objects for the vehicles in the simulation
        for idx = 1:length(structure.vehNode)
            obj(idx) = plot(node(idx).v_x(1),node(idx).v_y(1),markers(structure.vehNode(idx).vehicleType,:),'color',...
                            colours(structure.vehNode(idx).vehicleType,:),'MarkerSize', 20,...
                            'MarkerFaceColor',colours(structure.vehNode(idx).vehicleType,:));
            
            set(get(get(obj(idx),'Annotation'),'LegendInformation'),'IconDisplayStyle','off')
                        
            if typePos(1,structure.vehNode(idx).vehicleType)==0
                typePos(1,structure.vehNode(idx).vehicleType) = idx;
                set(get(get(obj(idx),'Annotation'),'LegendInformation'),'IconDisplayStyle','on')
            end
        end
    else
        % generate all the objects for the pedestrians in the simulation
        for idx = 1:length(structure.pedNode)
            obj(idx) = plot(node(idx).v_x(1),node(idx).v_y(1),'s','color',...
                            [0.2 0 0],'MarkerSize', 8, 'MarkerFaceColor',[0.2 0 0]);
            if idx~=1
                set(get(get(obj(idx),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
            end
        end
    end
end

