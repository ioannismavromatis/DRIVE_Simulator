function [signalLossLos,signalReceivedLos,signalLossNLos,signalReceivedNLos] = shadowFading(distance,BS)
%SHADOWFADING A shadow fading propagation model (used for mmWaves).
%  Starting with the freespace pathloss model, and adding the effect of the
%  mmWave link (shadow fading and an increase in the path loss based on the
%  distance seperation between two nodes). 
% 
%  This model can be found in: "Millemeter-Wave Communications: Physical
%  Channel Models, Design Considerations, Antenna Constructions, and Link
%  Budget", found under the following link:
%  https://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=8207426
%
%  The standard deviation values for the shadown fading were taken from 
%  "Overview of Millimeter Wave Communications for Fifth-Generation (5G) 
%  Wireless Networks-with a focus on Propagation Models", found under the 
%  following link: https://arxiv.org/pdf/1708.02557.pdf
%
%  Input  :
%     distance          : An array with all the potential distances
%     BS                : Structure containing all the informations about 
%                         the basestations.
%
%  Output :
%    signalLossLos      : The signal loss for the LOS distances (in dBm).
%    signalReceivedLos  : The signal received for the LOS distances (in dBm).
%    signalLossNLos     : The signal loss for the NLOS distances (in dBm).
%    signalReceivedNLos : The signal received for the NLOS distances (in dBm).
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk

    global SIMULATOR
    
    referenceDistance = 1; % 1 meter
    sigmaShadowLOS = 2; % Standard Deviation of Shadowing
    sigmaShadowNLOS = 7.82; % Standard Deviation of Shadowing
    shadowFadingLOS = lognrnd(0,sigmaShadowLOS, length(distance),1)';
    shadowFadingNLOS = lognrnd(0,sigmaShadowNLOS, length(distance),1)';

    freeSpaceLoss = 20*log10(referenceDistance) + 20*log10(BS.cFrequency) + ...
        20*log10(4*pi/SIMULATOR.constant.c) - (BS.bsGain + ...
        BS.mobileGain + BS.txPower);

    freeSpaceSignalReceived = BS.mobileGain + BS.bsGain + ...
        BS.txPower - ( 20*log10(referenceDistance) + ...
        20*log10(BS.cFrequency) + 20*log10(4*pi/SIMULATOR.constant.c) );
    
    
    signalLossLos = freeSpaceLoss + 10*BS.pathLossExponentLOS*log10(distance);
    signalReceivedLos = BS.mobileGain + BS.bsGain + ...
        BS.txPower - signalLossLos - shadowFadingLOS;
    
    signalLossNLos = freeSpaceLoss + 10*BS.pathLossExponentNLOS*log10(distance);
    signalReceivedNLos = BS.mobileGain + BS.bsGain + ...
        BS.txPower - signalLossNLos - shadowFadingNLOS;
end

