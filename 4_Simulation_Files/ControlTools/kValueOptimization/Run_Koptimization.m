clearvars; close all; clc;
addpath(genpath('..\..\WetiMatlabFunctions'))

%% Setup

ROSCO           = '..\..\OptSyria\ServoData\ROSCO_FB.IN'; 
FASTexeFile     = '..\..\OptSyria\openfast_x64.exe ';
SimulationName  = '..\..\OptSyria\OPTSyria5MW';
inflowFile      = '..\..\OptSyria\OPTSyria5MW_Inflow.dat';

WindSpeed       = 6.5;
WindSpeedString = sprintf('%.2f HWindSpeed', WindSpeed);
ManipulateTXTFile(inflowFile,'1 HWindSpeed', WindSpeedString);

initalKvalue = '2.492100000000      ! VS_Rgn2K';

k0 = 2.4921;
Deltak = 0.1;
N  = 1;

k_Result = zeros(N,2);

kVals = k0 - (0:N-1)*Deltak;                      % K values
kStr  = compose("%.12f      ! VS_Rgn2K", kVals);  % String with K values to replace

%% Run OpenFAST

for i=1:N
  ManipulateTXTFile(ROSCO,initalKvalue,kStr(i)); % Replace K

  dos([FASTexeFile,SimulationName,'.fst']); % Run OpenFAST

  Results              = ReadFASTbinaryIntoStruct([SimulationName,'.outb']);
  
  sProtation = 60/Results.RotSpeed(end); % seconds per rotation
  dt = Results.Time(2) - Results.Time(1);
  start_index = round((600 - 3*sProtation)/dt); % [(600 seconds) - (3*one rotation in seconds)]/dT
  P = mean(Results.GenPwr(start_index:end));
  k_Result(i,:) = [kVals(i) P]; % Store K and Power

  ManipulateTXTFile(ROSCO,kStr(i),initalKvalue);

end

%% Save and Finalize
% save('k_Result.mat','k_Result')
ManipulateTXTFile(inflowFile, WindSpeedString, '1 HWindSpeed');


