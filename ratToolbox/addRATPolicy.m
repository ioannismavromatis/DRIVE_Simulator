function potentialPos = addRATPolicy(potentialPos,BS,ratName,linkBudget)
%ADDRATPOLICY Generate one instance of the RAT configuration per potential
% position. This can be used later to change the configuration of
% differnent BSs and apply different policies.
%
%  Input  :
%     potentialPos   : The structure containing all the information about
%                      the potential positions for the BS and their characteristics.
%     BS             : Structure containing all the informations about the
%                      basestations.
%     ratName        : The name of RAT that will be used in this function.
%     linkBudget     : Structure containing all the informations for the
%                      linkbudget analysis of each different RAT.
%
%  Output :
%     potentialPos   : Adding the appropriate configuration and linkbudget 
%                      information for each potential basestation on the map.
%
% Copyright (c) 2019-2020, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
% email: ioannis.mavromatis@toshiba-bril.com

    for i = 1:length(potentialPos.(ratName).pos)
        potentialPos.(ratName).configuration(i) = BS.(ratName);
        potentialPos.(ratName).linkBudget(i) = linkBudget.(ratName);
    end
end

