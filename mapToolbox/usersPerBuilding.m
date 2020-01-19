function outputMap = usersPerBuilding(outputMap,timeStep,randomValues,coordinates,initialX,initialY,interpX,interpY,map)
%USERSPERBUILDING This function generates a number of users per building
%  randomly. These user contribute in the overall network load. 
%
%  This model was taken from "SPATIAL MODELING OF THE TRAFFIC DENSITY IN
%  CELLULAR NETWORKS", published in IEEE Wireless Communications Journal in
%  February 2014.
%
%  Input  :
%     outputMap    : The map structure extracted from the map file or loaded
%                    from the preprocessed folder.
%     timeStep     : The current simulation time (in seconds).
%     randomValues : Array containing all the information about the vehicles
%                    for the entire simulation time.
%     coordinates  : The edge of the map (rounded to 1 decimal point).
%     initialX     : A vector with five values equally spaced between the
%                    start and the end of the map (horizontal).
%     initialY     : A vector with five values equally spaced between the
%                    start and the end of the map (vertical).
%     map          : Structure containing all map settings (filename, path,
%                    simplification tolerance to be used, etc).
%
%  Output :
%     outputMap    : The map structure containing the new users per
%                    building information.
%
% Copyright (c) 2018-2019, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk

    tic
    
    if map.maxUsersPerBuilding == 0
        [xTemp,~] = meshgrid(coordinates(2,1):coordinates(2,2),coordinates(1,1):coordinates(1,2));
        outputMap.userPerSqMeter = zeros(size(xTemp));
        outputMap.usersPerBuilding = zeros(length(outputMap.buildingIncentre),1);
        return;
    end
    
    [X,Y] = meshgrid(initialX,initialY);
    
    % Values for the log-normal distribution for the downlink of an urban
    % environment.
    L = 10;
    mi = 18.93;
    sigma = 2.3991;

    % The maximum spatial spread
    omegaMax = 0.011592;

    % Generate a Gaussian Random Field to calculate the log-normally
    % distributed traffic density later.
    r = zeros(length(initialX),length(initialY));
    
    counter = timeStep;
    for i = 1:length(initialX)
        for j = 1:length(initialY)
            s = cos( randomValues(counter:counter+L-1).*(omegaMax*i) + randomValues(counter:counter+L-1).*(2*pi))  .* ...
                cos( randomValues(counter:counter+L-1).*(omegaMax*j) + randomValues(counter:counter+L-1).*(2*pi));
            counter = counter+L;
            r(i,j) = sum(s)*(2/sqrt(L));
        end
    end
    
    % Take the exponential function of the Gaussian Random Field to
    % calculate the traffic density on a city.
    r = exp(sigma*r + mi);

    % For debug purposes only
    % contourf(X,Y,r,'--')
    % colorbar
    
    % Interpolate the above value for the entire map
    [Xq,Yq] = meshgrid(interpX,interpY);
    userDensity = interp2(X,Y,r,Yq,Xq,'cubic');
%     userDensity = userDensity';
    
    % Normalise the user density to 1
    userDensity = userDensity - min(userDensity,[],'all');
    userDensity = userDensity/max(userDensity,[],'all');
    
    % For debug purposes only
    figure
    v = round(userDensity*map.maxUsersPerBuilding);
    v = v';
    contourf(Xq',Yq',v,'--')
    colorbar
    
    % Find the number of users per building per square meter
    userPerSqMeter = round(userDensity*map.maxUsersPerBuilding);
    
    % Number of users per building
    buildingCoordinates = round(outputMap.buildingIncentre(:,2:3));
    buildingCoordinates = [ buildingCoordinates(:,1) - coordinates(1,1) ...
                            buildingCoordinates(:,2) - coordinates(2,1) ];
    
    tmp = 1:length(buildingCoordinates);
    for i = 1:length(tmp)
        try
            usersPerBuilding(i,1) = userPerSqMeter(buildingCoordinates(i,1),buildingCoordinates(i,2));
        catch
            usersPerBuilding(i,1) = 0;
        end
    end
    
    outputMap.usersPerBuilding = usersPerBuilding;
    outputMap.userPerSqMeter = userPerSqMeter;
    
    verbose('Generating a new user density took: %f seconds.', toc); 
end

