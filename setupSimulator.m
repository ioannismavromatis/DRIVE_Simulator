function setupSimulator()
%SETUPSIMULATOR Add the different directories of the simulator in the path,
%  including the subfolders as well.
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
% email: ioannis.mavromatis@toshiba-bril.com
   
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
        if ismac || isunix
            tmp = system('pgrep sumo');
        elseif ispc
            [~,tmp] = system('tasklist /FI "IMAGENAME eq sumo.exe"');
            tmp = ~contains(tmp,'sumo.exe');
        else
            error('Unknown operating system. DRIVE is intended to be used with macOS, Linux and Windows OSs.')
        end
            
        if ~tmp 
            verbose('An instance from SUMO is already running in the background and it will be killed.')
            while ~tmp
                if ismac || isunix
                    system('killall sumo');
                    pause(1);
                    tmp = system('pgrep sumo');
                elseif ispc
                    system('taskkill /IM "sumo.exe" /F');
                    pause(1);
                    [~,tmp] = system('tasklist /FI "IMAGENAME eq sumo.exe"');
                    tmp = ~contains(tmp,'sumo.exe');
                end
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
