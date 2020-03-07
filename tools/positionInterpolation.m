function node = positionInterpolation(structure)
%POSITIONINTERPOLATION The linear position interpolation for both vehicles
%  and pedestrian mobility traces -- this is being used to manipulate the
%  data in a format that can be animated later.
%
%  Input  :
%     structure : A structure containing all the information about the
%                 vehicles/pedestrians (type, position at each timeslot, etc.)
%  Output :
%     node      : A structure with the interpolated positions for the
%                 vehicles/pedestrians.
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk  
% email: ioannis.mavromatis@toshiba-bril.com  

    if isempty(fieldnames(structure))
        node = [];
        return
    end
    
    timeSteps = 0:structure.simStep:structure.simTime;
    
    if isfield(structure, 'vehNode')
        for nodeIndex = 1:length(structure.vehNode)
            node(nodeIndex).v_x = interp1(structure.vehNode(nodeIndex).time,structure.vehNode(nodeIndex).x,timeSteps);
            node(nodeIndex).v_y = interp1(structure.vehNode(nodeIndex).time,structure.vehNode(nodeIndex).y,timeSteps);
        end
    else
        for nodeIndex = 1:length(structure.pedNode)
            node(nodeIndex).v_x = interp1(structure.pedNode(nodeIndex).time,structure.pedNode(nodeIndex).x,timeSteps);
            node(nodeIndex).v_y = interp1(structure.pedNode(nodeIndex).time,structure.pedNode(nodeIndex).y,timeSteps);
        end
    end
        

end

