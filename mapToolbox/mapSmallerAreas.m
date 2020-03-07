function outputMap = mapSmallerAreas(outputMap,map)
%mapSmallerAreas This function calls the appropriate method to seperate the
%  given map into smaller areas. The user chooses that by modifying the
%  parameter "map.areaShape" from the settings.
%
%  Input  :
%     map       : Structure containing all map settings (filename, path,
%                 simplification tolerance to be used, etc).
%     outputMap : The map structure extracted from the map file or loaded
%                 from the preprocessed folder.
%
%  Output :
%     outputMap : The map structure with the added information regarding
%                 the area tiles (either hexagonal or squared).
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
% email: ioannis.mavromatis@toshiba-bril.com

    if map.areaShape == 1
        % if a hexagonal area shape was chosen
        outputMap = smallerAreasHexagons(outputMap,map.area,'mapArea');
    elseif map.areaShape == 2
        % if a squared area shape was chosen
        outputMap = smallerAreasSquares(outputMap,map.area,'mapArea');
    else
        fprintf('The areaShape setting given is not recongised.\n')
        fprintf('Either "1" (for hexagons) or "2" (for squares) should be chosen.\n')
        error('Wrong areaShape setting')
    end
end

