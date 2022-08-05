%% MmWave links settings
ratName = 'mmWaves';
ratType = 'femto';
pathLossModel = 'freespace';
cFrequency = 60000000000; % carrier frequency given in Hz
txPower = 20; % given in dBm
noiseFloor = -174; % noise floor
noiseFigure = -6; % noise figure
cBandwidth=2160000000; % channel bandwidth in Hz
beamwidthAngle = 15; % default beamwidth for mmWaves - may be changed during the simulation time
bsHeight = [ 5 15 ]; % The range of heights that an mmWave basestation might be placed
mimo = 0; 
% The maximum distance that the mmWave signal can still be considered as
% received -- if a very big value is chosen, it will be adapted later given
% the mmWave link budget characteristics
maxTXDistance = 200; 
pathLossExponentLOS = 2.66;
pathLossExponentNLOS = 7.17;
femtoDistanceThreshold = 100; % The maximum distance separation between two femtocell basestations on a road

%% Modulation Schemes for mmWave links
% 7 MCS with different data rates - the 8th is when not transmitting
% The SNR values based on the sensitivity of MCSs, as given from IEEE
% 802.11ad standard
% 64-QAM 13/16 - 6756.75Mbps
% 64-QAM 5/8 - 5197.5Mbps
% 16-QAM 3/4 - 4158Mbps
% QPSK 1/2 - 1386Mbps
% SQPSK 5/8 - 866.25Mbps
% pi/2-BPSK 1/2 - 385Mbps
% pi/2-BPSK 1/2 27.5 Mbps

dataRate = [ 6756750000 5197500000 4158000000 1386000000 866250000 385000000 27500000 ];
sensitivityLevels = [ -47 -51 -54 -63 -64 -68 -78 ];