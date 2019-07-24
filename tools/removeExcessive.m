function [ array, numberPerTimeslot ] = removeExcessive(array,structure,timeSlot,timeDifference)
%removeExcessive Remove the excessive number of vehicles or pedestrians,
%  with respect to the number specified by the user.
%
%  Input  :
%     array     : Array with all the vehicles/pedestrian IDs and their timesteps.
%     structure : A structure containing all the information about the
%                 vehicles/pedestrians (type, position at each timeslot, etc.)
%     timeSlot  : The maximum time (in SUMO).
%     timeDifference : The timestep (in SUMO).
%
%  Output :
%     array   : The modified vehicles/pedestrian IDs array after normalising
%               the timesteps.
%     numberPerTimeslot : Number of removed vehicles per timeslot.
%
% Copyright (c) 2018-2019, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk

    if structure.maxNumber~=0
        uniqueIDs = unique(array(:,1));
        if length(uniqueIDs) > structure.maxNumber
            uniqueIDs = uniqueIDs(1:structure.maxNumber);
            maxID = max(uniqueIDs);
            toKeep = array(:,1)<=maxID;
            array = array(toKeep,:);
        end
    end

    numberPerTimeslot = zeros(1,timeSlot);
    slot = 0;
    for i=1:timeSlot
        numberPerTimeslot(i) = sum(array(:,2)==slot);
        slot = slot + timeDifference;
    end
end

