function [signalLossLos,signalReceivedLos,signalLossNLos,signalReceivedNLos] = urbanMacro(distance,BS)
%URBANMACRO Macro cell propagation model for urban areas. The LOS
%  pathloss model is described in to 3GPP TR 36.873 V12.0.0 and is 
%  applicable for frequencies ranging between 2 GHz and 6 GHz.
%  The NLOS model is the COST Hata model and is described in COST 231
%  Chapter 4.
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
% Copyright (c) 2018-2019, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk

    % The LOS model
    Dhb = 20; %Average antenna heigth (in meters) from the average rooftop level.
    signalLossLos = 40*(1-4*10^-3 * Dhb)*log10(distance/1000) - 18*log10(Dhb) + ...
                   21*log10(BS.cFrequency/10^6) + 80;    
    signalReceivedLos = (BS.bsGain + BS.mobileGain + BS.txPower) - signalLossLos;
    
    
    % The NLOS model - an average 40m height is considered for the BSs and
    % 1.5m for the mobile nodes
    bsHeight = 40;
    mobileHeight = 1.5;
    Cm = 3; % the constant offset - in dB
    if BS.cFrequency < 2*10^6
        alpha = 8.29 * log10(1.54*mobileHeight)^2 - 1.1;
    else
        alpha = 3.2 * log10(11.75*mobileHeight)^2 - 4.97;
    end
    
    signalLossNLos = 46.3 + 33.9 * log10(BS.cFrequency/10^6) - ...
                     13.82 * log10(bsHeight) - alpha + ( 44.9 - 6.55*log10(bsHeight) ) * ...
                     log10(distance/1000) + Cm;
    signalReceivedNLos = (BS.bsGain + BS.mobileGain + BS.txPower) - signalLossNLos;
end

