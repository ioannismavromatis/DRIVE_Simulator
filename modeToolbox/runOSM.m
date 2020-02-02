function runOSM(map,BS,outputMap,potentialPos,distanceTiles,sortedIndexes,losNlosStatus,rssAll)
%RUNOSM This is the main function of the OSM mode. 
%  It initialises the highestRSS, the servingBSs and the tiles covered
%  variables. Later, it iterates for all the timesteps and calculates the
%  users per area on each given timestep. It also updates the policies of
%  certain given BSs at specific times and recalculates the necessary variables.
%
%  Input  :
%     map           : Structure containing all map settings (filename, path,
%                     simplification tolerance to be used, etc).
%     outputMap     : The map structure containing all the map information.
%     potentialPos  : All the potential positions for all the different RATs.
%     distanceTiles : The distanceTiles of each tile from a given BS.
%     sortedIndexes : The sorted indexes for the tile close to BS, given
%                     from the closest to the furthest one.
%     losNlosStatus : The classification of each tile (LOS/NLOS) for a
%                     given BS - 0 is NLOS, 1 is LOS
%     rssAll        : The received signal strength for the all given tiles.
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
% email: ioannis.mavromatis@toshiba-trel.com

    tic 
    
    % Initialise the potential BS positions for all the communication planes.
    bsIDs{1} = 1:length(potentialPos.lte.pos);
    bsIDs{2} = randi(length(potentialPos.mmWaves.pos),1,300);
    
    for i = 1:length(bsIDs)
        [ servingBSId{i},highestRSS{i},highestRSSPlot{i},losNlos{i},tilesCoveredIDs{i},tilesCovered{i} ] = highestRSSValues(bsIDs{i},outputMap,sortedIndexes{i}, rssAll{i},losNlosStatus{i});
%         figure
%         heatmapPrint(outputMap,map,highestRSSPlot{i},bsIDs{i},potentialPos.(BS.rats{i}).pos,tilesCoveredIDs{i})    
    end
    
    timeStep = 1;
    % Initialise the user density in buildings
    [randomValues,coordinates,initialX,initialY,interpX,interpY] = ...
                   initialiseUsersPerBuilding(outputMap,'osm',map);
    close all;
    
    for i = 1:10 % iterate for 10 timeslots
        fprintf('The timestep is: %f\n',timeStep)

        outputMap = usersPerBuilding(outputMap,timeStep,randomValues,coordinates,initialX,initialY,interpX,interpY,map);
        
        [~,max_idx] = max(outputMap.userPerSqMeter(:));
        [xI, yI]=ind2sub(size(outputMap.userPerSqMeter),max_idx);
        
        highDemand = [ outputMap.bbox(1,1)+xI, outputMap.bbox(2,1)+yI ];
        
        [~,idxBS] = pdist2([potentialPos.lte.pos(:,2),potentialPos.lte.pos(:,1)],[ highDemand(2) highDemand(1)],'euclidean','Smallest',4);
        for l = 1:length(idxBS)
            potentialPos.lte.configuration(idxBS(l)).txPower = 43;
        end
        [~,~,rssAll{1},potentialPos.lte] = updateRSS(losNlosStatus{1},distanceTiles{1},sortedIndexes{1},potentialPos.lte,BS,'lte');
        [ servingBSId{1},highestRSS{1},highestRSSPlot{1},losNlos{1},tilesCoveredIDs{1},tilesCovered{1} ] = highestRSSValues(1:length(potentialPos.lte.pos),outputMap,sortedIndexes{1}, rssAll{1},losNlosStatus{1});
        if i == 10
            figure
            heatmapPrint(outputMap,map,highestRSSPlot{1},1:length(potentialPos.lte.pos),potentialPos.lte.pos,tilesCoveredIDs{1})
        end
%         hold on
%         plot(highDemand(2),highDemand(1),'rx','MarkerSize',40,'lineWidth',10)
        
        dataRateTmp = [];
        for l = 1:length(highestRSS{1})
            if servingBSId{1}(l)>=1
                if losNlos{1}(l) == 1
                    idx = potentialPos.lte.linkBudget(servingBSId{1}(l)).signalReceivedLos == highestRSS{1}(l);
                    dataRateTmp(l) = potentialPos.lte.linkBudget(servingBSId{1}(l)).dataRateLos(idx);
                else
                    idx = potentialPos.lte.linkBudget(servingBSId{1}(l)).signalReceivedNLos == highestRSS{1}(l);
                    dataRateTmp(l) = potentialPos.lte.linkBudget(servingBSId{1}(l)).dataRateNLos(idx);
                end
            else
                dataRateTmp(l) = 0;
            end
        end
        dataRate(timeStep) = mean(dataRateTmp);
        
        
        for l = 1:length(idxBS)
            potentialPos.lte.configuration(idxBS(l)).txPower = 15;
        end
        close all
        
        % Progress to the timestep
        timeStep = timeStep + 1;
        
    end
        
   fprintf('The average datarate for the no. 1 communication plane is: %f Mbits/s\n',mean(dataRate)/10^6);
 
end

