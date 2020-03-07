function [signalLossLos,signalReceivedLos,signalLossNLos,signalReceivedNLos] = freespace(distance,BS)
%FREESPACE Pathloss model for free space. A 20dBm increased loss is
%  considered for the NLos scenarios.
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
% email: ioannis.mavromatis@toshiba-bril.com

    global SIMULATOR
    signalLossLos = 20*log10(distance) + 20*log10(BS.cFrequency) + ...
        20*log10(4*pi/SIMULATOR.constant.c) - (BS.bsGain + ...
        BS.mobileGain + BS.txPower);

    signalReceivedLos = BS.mobileGain + BS.bsGain + ...
        BS.txPower - ( 20*log10(distance) + ...
        20*log10(BS.cFrequency) + 20*log10(4*pi/SIMULATOR.constant.c) );
    
    signalLossNLos = signalLossLos + 20;
    signalReceivedNLos = signalReceivedLos - 20;
end

