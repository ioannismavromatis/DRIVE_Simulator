function gain = antennaGainMacro(beamwidthAngle,frequency)
%ANTENNAGAINMACRO Calculate the antenna gain given the beamwidth angle for
%  a 3-sector cell sites and macrocell approach. This is described in 
%  3GPP TR 36.942 version 8.2.0 Release 8, subsection 4.2.1.1. The max
%  antenna gains are described in subsection 4.2.1.2.
%
%  Input  :
%     beamwidthAngle : The given antenna beamwidth (in degrees).
%     frequency      : The operational frequency of the antenna.
%
%  Output :
%     gain           : The calculated antenna gain.
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
% email: ioannis.mavromatis@toshiba-bril.com

    halfBeam = beamwidthAngle/2;
    
    if abs(frequency - 2*10^9) > abs(frequency - 900*10^6)
        maxAntennaGain = 15;
    else
        maxAntennaGain = 12;
    end
    
    gain = -min(12*(halfBeam/65)^2,20) + maxAntennaGain; 
end
