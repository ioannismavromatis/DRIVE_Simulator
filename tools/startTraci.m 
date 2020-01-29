function startTraci( sumo )
%startTraci Initialise SUMO execution using TraCI
%  This function starts by checking if SUMO path is within the MATLAB path.
%  If not it adds it in there. Later, SUMO is executed in the background
%  and linked with the TraCI library.
%
%  Input  :
%     sumo : Structure containing all the SUMO settings (maximum number of
%            vehicles, start time, end time, etc.)
%
% Copyright (c) 2018-2019, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk

    global SIMULATOR 
    
    % Run only when SUMO map is requested by the user
    if SIMULATOR.map == 1
        % Add SUMO path in the MATLAB path
        pathVar = getenv('PATH');
        if ~contains(pathVar,SIMULATOR.sumoPath)
            pathVar = [pathVar ':' SIMULATOR.sumoPath ];
            setenv('PATH', pathVar);
            verbose([ 'MATLAB path was modified. The new path is: ' pathVar ])
        end

        % Check whether the correct times were given by the user
        if sumo.startTime>=sumo.endTime
            error('The SUMO startTime should not be greater or equal to the endTime')
        end

        % Initialise SUMO or SUMO-GUI to run in the background
        sumoArgs = [ ' -b ' num2str(sumo.startTime)];
        if sumo.endTime > 0
            sumoArgs = [ sumoArgs ' -e ' num2str(sumo.endTime) ];
        end

        sumoArgs = [ sumoArgs ' --remote-port 8813 --xml-validation never&' ];
        if sumo.gui
            command = ['sumo-gui -c ' sumo.routeFile  sumoArgs];
        else
            command = ['sumo -c ' sumo.routeFile  sumoArgs];
        end
        system(command);

        % Initialise TraCI and link it with the current SUMO application ID
        [traciVersion,~] = traci.init();

        if traciVersion
            verbose('TraCI was initiated correctly and was connected with SUMO.')
        end
        
    elseif SIMULATOR.map == 0
        verbose('SUMO will not be initiated. Only an OSM map will be used from the simulation framework.')
    else
        error('A wrong value was given for the map type! Please use the correct type...')
    end
end