function highRSSValue = highestRSSBSPlacement(chosenRSUpos,losTileIDs, rssTile)
%highestRSSBSPlacement For the chosen RSU positions, calculate the highest received
%   signal strength per tile on the map. This function is being used by the
%   Genetic Algorithm implementation.
%
%  Input  :
%     chosenRSUpos : The positions of the chosen BSs.
%     losTileIDs   : Tile IDs that are in LOS with each BS.
%     rssTile      : The received signal strength for the LOS tiles.
%
%  Output :
%     highRSSValue    : The highest RSS for the chosen BSs (per tile). 
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
% email: ioannis.mavromatis@toshiba-bril.com

    % Initialise cumSum with zeros and calculate all the RSS values for all
    % the chose RSU positions
    cumSum = zeros(1,length(chosenRSUpos));
    cumSum(1) = length(rssTile{chosenRSUpos(1)});
    for i = 2:length(chosenRSUpos)
        cumSum(i) = cumSum(i-1) + length(rssTile{chosenRSUpos(i)});
    end
    rssValues = cell2mat(rssTile(chosenRSUpos));
    tileIDs = cell2mat(losTileIDs(chosenRSUpos));

    [uniqueIDs,~,~] = unique(tileIDs,'legacy');
    
    for i = 1:length(uniqueIDs)
        checkTiles = tileIDs == uniqueIDs(i);
        highRSSValue(i)= max(rssValues(checkTiles));
    end
end

