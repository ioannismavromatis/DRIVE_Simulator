function linkBudget = linkBudgetCalculation(BS)
%linkBudgetCalculation Calculating the necessary link budget information
% for a RAT technology.
%
%  Input  :
%     BS         : Structure to be filled with the basestation information
%  Ouput  :
%     linkBudget : Structure containing all the informations for the
%                  linkbudget analysis of the given RAT.
%
% Copyright (c) 2018-2019, Ioannis Mavromatis
% email: ioan.mavromatis@bristol.ac.uk
    
    if strcmp(BS.ratType,'femto')
        step = 0.1;
    else
        step = 1;
    end

    distance =step:step:BS.maxTXDistance;
    if strcmp(BS.ratType,'femto')
        distance = round(distance,1);
    else
        distance = round(distance,0);
    end

    % Find the received signal for all the distances and calculate the
    % Signal-to-Noise-Ratio
    functionHandle = str2func(BS.pathLossModel);
    [ signalLossLos, signalReceivedLos, signalLossNLos, signalReceivedNLos ] = functionHandle(distance,BS);

    SNRlos = signalReceivedLos - BS.rssNoise;
    SNRNlos = signalReceivedNLos - BS.rssNoise;

    % find where signal loss is greater than the minimum sensitivity of
    % the RAT used and suppress the maximum distance to that value
    maxBeamLengthIDLos = find(signalReceivedLos < BS.sensitivityLevels(end), 1, 'first' );
    if isempty(maxBeamLengthIDLos)
        maxBeamLengthIDLos = length(distance);
    else
        maxBeamLengthIDLos = maxBeamLengthIDLos - 1;
    end
    linkBudget.distanceLos = distance(1:maxBeamLengthIDLos);
    linkBudget.signalLossLos = signalLossLos(1:maxBeamLengthIDLos);
    linkBudget.signalReceivedLos = signalReceivedLos(1:maxBeamLengthIDLos);
    
    maxBeamLengthIDNLos = find(signalReceivedNLos < BS.sensitivityLevels(end), 1, 'first' );
    if isempty(maxBeamLengthIDNLos)
        maxBeamLengthIDNLos = length(distance);
    else
        maxBeamLengthIDNLos = maxBeamLengthIDNLos - 1;
    end
    linkBudget.distanceNLos = distance(1:maxBeamLengthIDNLos);
    linkBudget.signalLossNLos = signalLossNLos(1:maxBeamLengthIDNLos);
    linkBudget.signalReceivedNLos = signalReceivedNLos(1:maxBeamLengthIDNLos);

    % generate a lookup table for all the datarates, given the link margins
    % and the SNR
    modScheme = bsxfun(@ge, SNRlos', BS.linkMargins);
    [ ~, modIndexLos ] = max(modScheme, [], 2);

    modScheme = bsxfun(@ge, SNRNlos', BS.linkMargins);
    [ ~, modIndexNLos ] = max(modScheme, [], 2);
    
    modIndexLos = modIndexLos(1:maxBeamLengthIDLos);
    modIndexNLos = modIndexLos(1:maxBeamLengthIDNLos);
    linkBudget.dataRateLos = BS.dataRate(modIndexLos);
    linkBudget.dataRateNLos = BS.dataRate(modIndexNLos);
end

