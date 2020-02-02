function colours = generateColours(structure)
%generateColours This function generates an array of colours that will be
%  given to the different vehicles later.
%
%  Input  :
%     structure : A structure containing all the information about the
%                 vehicles/pedestrians (type, position at each timeslot, etc.)
%  Output :
%     typePos   : The array of colours to be used for the given vehicle
%                 types
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
% email: ioannis.mavromatis@toshiba-trel.com

    % Create an initial array of colours
    colours(1,:) = [ 1 0 0 ];
    colours(2,:) = [ 0 1 0 ];
    colours(3,:) = [ 0 0 1 ];
    colours(4,:) = [ 1 1 0 ];
    colours(5,:) = [ 0 1 1 ];
    colours(6,:) = [ 1 1 1 ];

    % Either add more colours if the number of vehicle types exceeds six,
    % or return the required colours to the printAnimation function.
    if length(structure.type)>length(colours)
        tmpColours = rand(length(structure.type)-length(colours),3);
        colours = [ colours ; tmpColours ];
    else
        colours = colours(1:length(structure.type),:);
    end
    
end

