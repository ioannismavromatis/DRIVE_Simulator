function [vehicles,pedestrians] = ...
            runSUMO(sumo,map,BS,outputMap,potentialPos,distanceTiles,...
            sortedIndexes,losNlosStatus,rssAll,distanceBuildings, sortedIndexesBuildings, rssAllBuildings)
%RUNSUMO This is the main function of the SUMO mode. It initialises the
% highestRSS, the servingBSs and the tiles covered variables. Later, it
% iterates for all the timesteps and calculates the users per area on each
% given timestep. It also updates the policies of certain given BSs at
% specific times and recalculates the necessary variables.
%
%  Input  :
%     sumo             : Structure containing all the SUMO settings (maximum
%                        number of vehicles, start time, end time, etc.)
%     map              : Structure containing all map settings (filename, path,
%                        simplification tolerance to be used, etc).
%     outputMap        : The map structure containing all the map information.
%     potentialPos     : All the potential positions for all the different RATs.
%     distanceTiles    : The distanceTiles of each tile from a given BS.
%     sortedIndexes    : The sorted indexes for the tile close to BS, given
%                        from the closest to the furthest one.
%     losNlosStatus    : The classification of each tile (LOS/NLOS) for a
%                        given BS - 0 is NLOS, 1 is LOS
%     rssAll           : The received signal strength for the all given tiles.
%     distanceBuilding : The distance of each building from a given BS.
%     sortedIndexesBuildings : The sorted indexes for the building close to BS, given
%                              from the closest to the furthest one.
%     rssAllBuildings  : The received signal strength for the all given buildings.
%
%  Output :
%     vehicles         : Array containing all the information about the
%                        vehicles for the entire simulation time.
%     pedestrians      : Array containing all the information about the
%                        pedestrians for the entire simulation time.
%
% Copyright (c) 2018-2019, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk

    tic 
    
    % Initialise the potential BS positions for all the communication
    % planes.
    bsIDs{1} = 1:length(potentialPos.lte.pos);
    randomPos = 30;
%     if length(potentialPos.mmWaves.pos)<=randomPos
%         randomPos = length(potentialPos.mmWaves.pos);
%     end
%     bsIDs{2} = randi(length(potentialPos.mmWaves.pos),1,randomPos);
%     bsIDs{2} = unique(bsIDs{2});
    bsIDs{2} = 2;
    
    for i = 1:length(bsIDs)
        [ servingBSId{i},highestRSS{i},highestRSSPlot{i},losNlos{i},tilesCoveredIDs{i},tilesCovered{i} ] = highestRSSValues(bsIDs{i},outputMap,sortedIndexes{i}, rssAll{i},losNlosStatus{i});
        figure
        heatmapPrint(outputMap,map,highestRSSPlot{i},bsIDs{i},potentialPos.(BS.rats{i}).pos,tilesCoveredIDs{i})    
    end
    
    % Progress to the first simulation step
    traci.simulationStep;
    timeStep = traci.simulation.getTime;
    
    % Initialise the user density in buildings
    [randomValues,coordinates,initialX,initialY,interpX,interpY] = initialiseUsersPerBuilding(outputMap,'sumo',map,sumo);
    outputMap = usersPerBuilding(outputMap,timeStep,randomValues,coordinates,initialX,initialY,interpX,interpY,map);
    
    % Create the vehicle and pedestrian arrays
    vehicles = [];
    pedestrians = [];
    close all;
    
    % Start iterating for all the timesteps
    for i = 1:sumo.endTime
        vehicleIDs = traci.vehicle.getIDList();
        pedestrianIDs = traci.person.getIDList();
        timeStep = traci.simulation.getTime;
        fprintf('The timestep is: %f\n',timeStep)
        
        [ vehicleTimestep, pedestrianTimestep ] = getVehiclesAndPedestrians(sumo,vehicleIDs,pedestrianIDs,timeStep);
        vehicles = [ vehicles ; vehicleTimestep ];
        pedestrians = [ pedestrians ; pedestrianTimestep ];
        
        [distanceVehicleArea,idxVehicleArea,distancePedestrianArea,idxPedestrianArea,usersPerArea] = ...
            usersPerAreaCalculation(outputMap,vehicleTimestep,pedestrianTimestep);

        [distanceVehicleTile,idxVehicleTile,distancePedestrianTile,idxPedestrianTile] = ...
            nearbyTile(outputMap,vehicleTimestep,pedestrianTimestep);
        
        for k = 1:length(BS.rats)        
            rssHighest = highestRSS{k}(idxVehicleTile);
            bsServing = servingBSId{k}(idxVehicleTile);
            losNlosLink = losNlos{k}(idxVehicleTile);
        
            dataRateTmp = [];
            for l = 1:length(rssHighest)
                if bsServing(l)>=1
                    if losNlosLink(l) == 1
                        idx = potentialPos.(BS.rats{k}).linkBudget(bsServing(l)).signalReceivedLos == rssHighest(l);
                        dataRateTmp(l) = potentialPos.(BS.rats{k}).linkBudget(bsServing(l)).dataRateLos(idx);
                    else
                        idx = potentialPos.(BS.rats{k}).linkBudget(bsServing(l)).signalReceivedNLos == rssHighest(l);
                        dataRateTmp(l) = potentialPos.(BS.rats{k}).linkBudget(bsServing(l)).dataRateNLos(idx);
                    end
                else
                    dataRateTmp(l) = 0;
                end
            end
            dataRate{k}(timeStep) = mean(dataRateTmp);        
        end
        
        if mod(timeStep,50)==0 && timeStep <= 100
            
            outputMap = usersPerBuilding(outputMap,timeStep,randomValues,coordinates,initialX,initialY,interpX,interpY,map);

            [~,max_idx] = max(outputMap.userPerSqMeter(:));
            [xI, yI]=ind2sub(size(outputMap.userPerSqMeter),max_idx);
            
            highDemand = [ outputMap.bbox(1,1)+xI, outputMap.bbox(2,1)+yI ];
            
            [~,idxBS] = pdist2([potentialPos.lte.pos(:,2),potentialPos.lte.pos(:,1)],[ highDemand(2) highDemand(1)],'euclidean','Smallest',4);
            for l = 1:length(idxBS)
            	potentialPos.lte.configuration(idxBS(l)).txPower = 43;
            end
            [~,~,rssAll{1},potentialPos.lte] = updateRSS(losNlosStatus{1},distanceTiles{1},sortedIndexes{1},potentialPos.lte,BS,'lte');
            rssAllBuildings2{1} = updateRSSBuildings(distanceBuildings{1},potentialPos.lte,BS,'lte');
            
            [ servingBSId{1},highestRSS{1},highestRSSPlot{1},losNlos{1},tilesCoveredIDs{1},tilesCovered{1} ] = highestRSSValues(1:length(potentialPos.lte.pos),outputMap,sortedIndexes{1}, rssAll{1},losNlosStatus{1});
%             figure
%             heatmapPrint(outputMap,map,highestRSSPlot{1},1:length(potentialPos.lte.pos),potentialPos.lte.pos,tilesCoveredIDs{1})    
%             hold on
%             plot(highDemand(2),highDemand(1),'rx','MarkerSize',40,'lineWidth',10)
            
            for l = 1:length(idxBS)
            	potentialPos.lte.configuration(idxBS(l)).txPower = 15;
            end
            [~,~,rssAll{1},potentialPos.lte] = updateRSS(losNlosStatus{1},distanceTiles{1},sortedIndexes{1},potentialPos.lte,BS,'lte');
            [ servingBSId{1},highestRSS{1},highestRSSPlot{1},losNlos{1},tilesCoveredIDs{1},tilesCovered{1} ] = highestRSSValues(1:length(potentialPos.lte.pos),outputMap,sortedIndexes{1}, rssAll{1},losNlosStatus{1});
            close all
        end
        % Progress to the timestep
        traci.simulationStep;
        
    end
    
    for i = 1:length(dataRate)
        fprintf('The average datarate for the no. %d communication plane is: %f Mbits/s\n',i,mean(dataRate{i})/10^6);
    end
    
    verbose('The entire SUMO mode took: %f seconds.', toc); 
end

