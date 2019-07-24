function outputMap = mapTiles(outputMap,map)
%mapTiles This function calls the appropriate method to seperate the
%  given map into smaller tiles. The user chooses that by modifying the
%  parameter "map.tileShape" from the settings. For each map area
%  calculated before, the tile incentres that are within the area are
%  calculated as well.
%
%  Input  :
%     map       : Structure containing all map settings (filename, path,
%                 simplification tolerance to be used, etc).
%     outputMap : The map structure extracted from the map file or loaded
%                 from the preprocessed folder
%
%  Output :
%     outputMap : The map structure with the added information regarding
%                 all the tiles on the map (either hexagonal or squared).
%
% Copyright (c) 2018-2019, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk

    if map.tileShape == 1
        outputMap = smallerAreasHexagons(outputMap,map.tileSize);
        outputMap = tilesWithinAreas(outputMap);
    elseif map.tileShape == 2
        outputMap = smallerAreasSquares(outputMap,map.tileSize);
        outputMap = tilesWithinAreas(outputMap);
    else
        fprintf('The tileShape setting given is not recongised.\n')
        fprintf('Either "1" (for hexagons) or "2" (for squares) should be chosen.\n')
        error('Wrong tileShape setting')
    end
end


