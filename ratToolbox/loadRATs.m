function [ BS, linkBudget, map ] = loadRATs(BS,linkBudget,map)
%LOADRATS Load all the available RATs and initialise their functionality.
%  The available RATs can be found under ratToolbox/available and they are
%  two-fold. They can either be a macro-cell RAT or a femto-cell RAT. Their
%  main different is their mounting positions around the map.
%
%  Input  :
%     BS         : Structure to be filled with the basestation information
%     linkBudget : Structure to be filled with the link budget information
%     map        : Structure containing all map settings (filename, path,
%                  simplification tolerance to be used, etc).
%  Ouput  :
%     BS         : Structure containing all the informations about the basestations.
%     linkBudget : Structure containing all the informations for the
%                  linkbudget analysis of each different radio access technology.
%     map        : Extend the map structure with the femto- and macro-cell
%                  information.
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
% email: ioannis.mavromatis@toshiba-trel.com

    tic
    files = dir('./ratToolbox/available/*.m');
    for i=1:length(files)
        % Load all the variables from the settings file
        run(files(i).name);

        % Add the name of the technology in the RAT matrix
        BS.rats{i} = ratName;

        % Calculate the reseived signal noise from the given values
        BS.(ratName).rssNoise = noiseFloor + 10*log10(cBandwidth) + noiseFigure; % noise_power
        
        % Add all the variables in the appropriate structure
        BS.(ratName).ratType = ratType;
        BS.(ratName).cBandwidth = cBandwidth;
        BS.(ratName).cFrequency = cFrequency;
        
        BS.(ratName).noiseFigure = noiseFigure;
        BS.(ratName).noiseFloor = noiseFloor;
        BS.(ratName).sensitivityLevels = sensitivityLevels;
        BS.(ratName).txPower = txPower;
        BS.(ratName).beamwidthAngle = beamwidthAngle;
        BS.(ratName).dataRate = dataRate;
        BS.(ratName).mimo = mimo;
        BS.(ratName).maxTXDistance = maxTXDistance;
        BS.(ratName).pathLossModel = pathLossModel;
        BS.(ratName).pathLossExponentLOS = pathLossExponentLOS;
        if exist('pathLossExponentNLOS','var')
            BS.(ratName).pathLossExponentNLOS = pathLossExponentNLOS;
        else
            BS.(ratName).pathLossExponentNLOS = pathLossExponentLOS;
        end
        
        
        
        BS.(ratName).linkMargins = sensitivityLevels - BS.(ratName).rssNoise;
        
        % Calculate the antenna gains - if not given
        if ~exist('bsGain','var')
            if strcmp(BS.(ratName).ratType,'femto')
                BS.(ratName).bsGain = antennaGainFemto(beamwidthAngle);
            else
                BS.(ratName).bsGain = antennaGainMacro(beamwidthAngle,BS.(ratName).cFrequency);
            end
        else
            BS.(ratName).bsGain = bsGain;
        end
        
        if ~exist('mobileGain','var')
            if strcmp(BS.(ratName).ratType,'femto')
                BS.(ratName).mobileGain = antennaGainFemto(beamwidthAngle);
            else
                BS.(ratName).mobileGain = antennaGainMacro(beamwidthAngle,BS.(ratName).cFrequency);
            end
        else
            BS.(ratName).mobileGain = mobileGain;
        end
        
        if strcmp(ratType,'femto')
            BS.(ratName).height = height;
            map.femtoDistanceThreshold = femtoDistanceThreshold;
        elseif strcmp(ratType,'macro')
            map.macroDensity = macroDensity;
        end
        
        % Perform the link budget analysis for all the potential distances
        linkBudget.(ratName) = linkBudgetCalculation(BS.(ratName));
        
    end
    verbose('Loading all the RATs and calculating the link budget took %f seconds.', toc);
end

