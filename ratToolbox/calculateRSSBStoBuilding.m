function [distanceBuilding, sortedIndexes, rssAll] = ...
             calculateRSSBStoBuilding(outputMap,potentialPos,BS,ratName)
%CALCULATERSSBSTOBUILDING Calculate the distance from each building
%  incentre and all the potential basestation positions. Later, calculate
%  the RSS for that given given configuration. 
%  Important. We always assume that the building incentre will be in NLOS
%  compared to the basestation (as all user are in an indoor envrironment)
%
%  Input  :
%     outputMap        : The map structure extracted from the map file or loaded
%                        from the preprocessed folder and updated until this point.
%     potentialPos     : All the potential positions generated from this
%                        function for all the different RATs.
%     BS               : Structure containing all the informations about the
%                        basestations.
%     ratName          : The name of RAT that will be used in this function.
%
%  Output :
%     distanceBuilding : The distance of each building from a given BS.
%     sortedIndexes    : The sorted indexes for the building close to BS, given
%                        from the closest to the furthest one.
%     rssAll           : The received signal strength for the all given buildings.
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
% email: ioannis.mavromatis@toshiba-bril.com

    global SIMULATOR
    
    % calculate all the distances and sort them based on their index
    [ distanceBuilding, sortedIndexes] = pdist2([ outputMap.buildingIncentre(:,3) outputMap.buildingIncentre(:,2) outputMap.buildingIncentre(:,4)],...
        [ potentialPos.pos(:,2) potentialPos.pos(:,1) potentialPos.pos(:,3) ],'euclidean','Radius',BS.(ratName).maxTXDistance);


    % round the values of the distance given the type of the RAT
    if strcmp(BS.(ratName).ratType,'femto')
        distanceBuilding = cellfun(@(x)round(x,1),distanceBuilding,'UniformOutput',false);
    else
        distanceBuilding = cellfun(@(x)round(x,0),distanceBuilding,'UniformOutput',false);
    end
    
    % find the maximum NLOS distance to filter the RSS values later
    if ~isempty(potentialPos.linkBudget(1).distanceNLos)
        maxNlosDistance = potentialPos.linkBudget(1).distanceNLos(end);
    else
        for i = 1:length(distanceBuilding)
            rssAll{i} = [];
        end
        return
    end

    % find the RSS values for all the calculated distances
    parfor (i = 1:length(distanceBuilding),SIMULATOR.parallelWorkers)
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

