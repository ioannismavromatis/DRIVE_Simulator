function setupSimulator()
%SETUPSIMULATOR Add the different directories of the simulator in the path,
%  including the subfolders as well.
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
   
    global SIMULATOR
    
    % Extract path
    fileName = mfilename('fullpath');
    modName = fileparts(fileName);
    addpath(modName);
    
    % Add all the modules in the path
    fprintf('Adding all modules and their subfolders to the path\n');
    modules = {'tools',...
               'animate',...
               'basestationToobox',...
               'externalToolbox',...
               'loadFiles',...
               'mapToolbox'...
               'modeToolbox',...
               'parsingToolbox',...
               'polygonToolbox',...
               'ratToolbox',...
               'sumoToolbox'};
    
    % Add all modules to path
    addModules(modules);
    verbose('All modules were added successfully')
    
    if SIMULATOR.map
        % Kill SUMO instance if running
        tmp = system('pgrep sumo');
        if ~tmp 
            verbose('An instance from SUMO is already running in the background and it will be killed.')
            while ~tmp
                system('killall sumo');
                pause(1);
                tmp = system('pgrep sumo');
            end
        end
    end
    
    % Initialise the parallel workers (if needed). If serial execution was
    % chosen, the given parallelWorkers parameter will be set to default (0)
    if SIMULATOR.parallelRun
        s = gcp;
        if ~s.Connected
            parpool(SIMULATOR.parallelWorkers);
            
        end
        verbose('Parallel pool was initiated successfully')
    else
        SIMULATOR.parallelWorkers = 0;
    end

end

function addModules( modules )
    % Add each module in the path
    for i = 1:length(modules)
        path = genpath(modules{i});
        addpath(path);
        verbose('Adding module: %-20s (ok)', modules{i});
    end
end
