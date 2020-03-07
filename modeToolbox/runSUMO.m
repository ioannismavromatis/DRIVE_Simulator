function [vehicles,pedestrians] = ...
            runSUMO(sumo,map,BS,outputMap,potentialPos,chosenRSUpos, tilesCovered,distanceTiles,...
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
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
% email: ioannis.mavromatis@toshiba-trel.com

    global VERBOSELEVEL
    tic 
    
    % For debug purposes only
    if VERBOSELEVEL >= 1
        for i = 1:length(BS.rats)
            ratName = BS.rats{i};
            [ servingBSId.(ratName),highestRSS.(ratName),highestRSSPlot.(ratName),losNlos.(ratName),tilesCoveredIDs.(ratName), tilesNum.(ratName) ] = ...
                          highestRSSValues(chosenRSUpos.(ratName),outputMap,sortedIndexes{i}, rssAll{i},losNlosStatus{i});
            figure
            heatmapPrint(outputMap,map,highestRSSPlot.(ratName),chosenRSUpos.(ratName),potentialPos.(ratName).pos,tilesCoveredIDs.(ratName))    
        end
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
            rssHighest = highestRSS.(BS.rats{k})(idxVehicleTile);
            bsServing = servingBSId.(BS.rats{k})(idxVehicleTile);
            losNlosLink = losNlos.(BS.rats{k})(idxVehicleTile);
        
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
        
        if mod(timeStep,50)==0 || timeStep==0
            ratName = 'lte';
            outputMap = usersPerBuilding(outputMap,timeStep,randomValues,coordinates,initialX,initialY,interpX,interpY,map);
            
            expectedTXPower = outputMap.userPerSqMeter/100*23+20;
            
            [Xq,Yq] = meshgrid(interpX,interpY);
            Xq = Xq';
            Yq = Yq';
            for kk = 1:length(potentialPos.(ratName).pos)
                
                [~,tmpIdx] = pdist2([ Yq(:) Xq(:) ],[potentialPos.(ratName).pos(kk,2),potentialPos.(ratName).pos(kk,1)],'euclidean','Smallest',1);
                tmp = expectedTXPower(:);
                potentialPos.(ratName).configuration(kk).txPower = round(tmp(tmpIdx));
            end
 
            [~,~,rssAll{1},potentialPos.lte] = updateRSS(losNlosStatus{1},distanceTiles{1},sortedIndexes{1},potentialPos.lte,BS,'lte');
            rssAllBuildings2{1} = updateRSSBuildings(distanceBuildings{1},potentialPos.(ratName),BS,'lte');
            
            [ servingBSId.(ratName),highestRSS.(ratName),highestRSSPlot.(ratName),losNlos.(ratName),tilesCoveredIDs.(ratName), tilesNum.(ratName) ] = ...
                      highestRSSValues(chosenRSUpos.(ratName),outputMap,sortedIndexes{1}, rssAll{1},losNlosStatus{1});
        
%             figure
%             heatmapPrint(outputMap,map,highestRSSPlot.(ratName),chosenRSUpos.(ratName),potentialPos.(ratName).pos,tilesCoveredIDs.(ratName))    
%             hold on
%             plot(interpY(yImax),interpX(xImax),'gx','MarkerSize',40,'lineWidth',10)
                        
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

