function gain = antennaGainFemto(beamwidthAngle)
%ANTENNAGAIN Calculate the antenna gain given the beamwidth angle
%
%  Input  :
%     beamwidthAngle : The given antenna beamwidth (in degrees).
%
%  Output :
%     gain           : The calculated antenna gain.
%
% Copyright (c) 2018-2019, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk

    directivity = (4*pi*(180/pi)^2)/(beamwidthAngle^2);
    gain = 10*log10(directivity);
end

