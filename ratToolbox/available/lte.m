%% LTE links settings
ratName = 'lte';
ratType = 'macro';
pathLossModel = 'urbanMacro';
cFrequency = 2600000000; % carrier frequency given in Hz
txPower = 15; % given in dBm
noiseFloor = -174; % noise floor
noiseFigure = -6; % noise figure
cBandwidth=20000000; % channel bandwidth in Hz
beamwidthAngle = 120; % default beamwidth for mmWaves - may be changed during the simulation time
mimo = 0; % give 0 for SISO channel and 1 for MIMO 4x4
bsGain = 18; % the antenna gain of the basestation
mobileGain = 0;  % the antenna gain of the mobile station
pathLossExponentLOS = 2.4;
macroDensity = 0.5; % The number of basestations per square km.

% The maximum distance that the LTE signal can still be considered as
% received -- if a very big value is chosen, it will be adapted later given
% the mmWave link budget characteristics
maxTXDistance = 1000; 

%% Modulation Schemes for LTE links
% 4 MCS with different data rates at 20MHz channel bandwidth 

% No MIMO
% 256-QAM 0.9258 - 97.896Mbps
% 64-QAM 0.8525 - 75.376Mbps
% 16-QAM 0.6016 - 30.576Mbps
% QPSK 0.4385 - 15.84Mbps

% MIMO 4x4
% 256-QAM 0.9258 - 391.584Mbps
% 64-QAM 0.8525 - 301.504Mbps
% 16-QAM 0.6016 - 122.304Mbps
% QPSK 0.4385 - 63.36Mbps

if mimo == 0
    dataRate = [ 97896000 75376000 30576000 15840000 ];
else
	dataRate = [ 391584000 301504000 122304000 63360000 ];
end
sensitivityLevels = [ -72 -77 -83 -94 ];