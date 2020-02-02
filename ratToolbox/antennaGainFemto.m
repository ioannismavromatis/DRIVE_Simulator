function gain = antennaGainFemto(beamwidthAngle)
%ANTENNAGAIN Calculate the antenna gain given the beamwidth angle
%
%  Input  :
%     beamwidthAngle : The given antenna beamwidth (in degrees).
%
%  Output :
%     gain           : The calculated antenna gain.
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
% email: ioannis.mavromatis@toshiba-trel.com

    directivity = (4*pi*(180/pi)^2)/(beamwidthAngle^2);
    gain = 10*log10(directivity);
end

