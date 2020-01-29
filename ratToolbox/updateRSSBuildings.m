function rssAll = updateRSSBuildings(distanceBuilding,potentialPos,BS,ratName)
%UPDATERSSBUILDINGS If the configuration of a number of basestations is changed
%  during the execution time, recalculate the RSS values given the already
%  known distances from the buildings.
%
%  Input  :
%     distanceBuilding  : The distance of each building from a given BS.
%     potentialPos      : The structure containing all the information about
%                         the potential positions for the BS and their characteristics.
%     BS                : Structure containing all the informations about the
%                         basestations.
%     ratName           : The name of RAT that will be used in this function.
%
%  Output :
%     rssAll            : The received signal strength for the all given buildings.
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk

    global SIMULATOR
    
    % find the RSS values for all the calculated distances
    parfor (i = 1:length(distanceBuilding),SIMULATOR.parallelWorkers)
        maxNlosDistance = potentialPos.linkBudget(i).distanceNLos(end);
        if ~isempty(distanceBuilding{i})
            if strcmp(BS.(ratName).ratType,'macro')
                if distanceBuilding{i}(1)==0
                    distanceBuilding{i}(1)=1;
                end
                distanceIdx = distanceBuilding{i}<maxNlosDistance;
                rssAll{i} = potentialPos.linkBudget(i).signalReceivedNLos(distanceBuilding{i}(distanceIdx));
            else
                if distanceBuilding{i}(1)==0
                    distanceBuilding{i}(1)=1;
                end
                distanceIdx = distanceBuilding{i}<maxNlosDistance;
                rssAll{i} = potentialPos.linkBudget(i).signalReceivedNLos(distanceBuilding{i}(distanceIdx)*10);
            end
        else
            rssAll{i} = [];
        end
    end
end

