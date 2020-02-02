function array = normaliseTime(array,minTime)
%NORMALISETIME This function normalises the vehicle/pedestrian IDs and 
% timestamps, in the case that SUMO was not started at 0 time or in the 
% case that the first ID is not 0. If this is
% not the case, then nothing happens.
%
%  Input  :
%     array   : Array with all the vehicles/pedestrian IDs and their timesteps.
%     minTime : The initial time from SUMO.
%
%  Output :
%     array   : The modified vehicles/pedestrian IDs array after
%               normalising the timesteps.
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
% email: ioannis.mavromatis@toshiba-trel.com

    if min(minTime)~=0 || min(array.id)~=0
        minID = min(array.id);
   
        array.vehicleID = array.id - minID;
        array.timestep = array.timestep - minTime;
    end
end

