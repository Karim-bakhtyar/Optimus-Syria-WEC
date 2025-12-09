%% Feedback controller team
%  script for getting steady state values of pitch and rotor speed

%% Changes you should do before running!
%  in .fst file => sim. time should be 600s, 
%  in elastodyn => only enable genDOF,TwFADOF1; no initial conditions set 
%  in inflowFile.dat => WindType=1, PLexp=0.2
%
%  don't forget check SimulationName.
%  it is running for feedback
%% Setup
clearvars;close all;clc;
addpath(genpath('..\WetiMatlabFunctions'))

FASTexeFile     = 'openfast_x64.exe';
SimulationName  = 'OPTSyria5MW';
copyfile(['..\OpenFAST\',FASTexeFile],FASTexeFile)

%Initialize a table to store the results
SteadyStates = table( ...
    'Size', [0, 6], ...
    'VariableTypes', {'double', 'double', 'double','double','double','double'}, ...
    'VariableNames', {'WindSpeed_ms', 'AvgBladePitch_deg', 'AvgRotorSpeed_rpm', 'TTDspFA','avg_M_G','avg_P'} ...
);


%% Run FB

previousWS = '1 HWindSpeed'; % initial string to start
for WindSpeed = 1:1:25 % values between CIN and COUT WS
    currentWS = previousWS; % string that is currently in inflow.dat 
    replacementWS = [num2str(WindSpeed), ' HWindSpeed']; % WS string that is going to run in this iteration

    % ManipulateTXTFile('text file you want to edit','string you want to change','new string that you want to add')
    ManipulateTXTFile('OPTSyria5MW_Inflow.dat',currentWS,replacementWS); % edit the wind speed in inflow.dat file

    dos(['openfast_x64.exe ',SimulationName,'.fst']); % run simulation

    Results              = ReadFASTbinaryIntoStruct([SimulationName,'.outb']); % read the results
    
    %In order to only get settled values we should get the mean of last 3 rotations
    sProtation = 60/Results.RotSpeed(end); % seconds per rotation
    dt = Results.Time(2) - Results.Time(1);
    start_index = round((600 - 3*sProtation)/dt); % [(600 seconds) - (3*one rotation in seconds)]/dT

    % Calculate steady-state averages
    avg_pitch = mean(Results.BldPitch1(start_index:end)); % get the mean value of blade pitch in last 60 seconds
    avg_rotspeed = mean(Results.RotSpeed(start_index:end)); % get the mean value of RotSpeed in last 60 seconds
    avg_M_G = mean(Results.GenTq(start_index:end));
    avg_P = mean(Results.GenPwr(start_index:end));
    avg_TTDspFA = mean(Results.TTDspFA(start_index:end));

    % Create a new row of data (ws, pitch, rotspeed)
    new_row = table(Results.Wind1VelX(end), avg_pitch, avg_rotspeed, avg_TTDspFA, avg_M_G, avg_P, ...
        'VariableNames', {'WindSpeed_ms', 'AvgBladePitch_deg', 'AvgRotorSpeed_rpm', 'TTDspFA','avg_M_G','avg_P'}); % created a row for corresponding WS in iteration

    % Append the new row to the main results table
    SteadyStates = [SteadyStates; new_row]; % adding the created row at the end of the result table

    previousWS = replacementWS; % replacing the previousWS string at the end of the iteration
end

%% Clean up
delete(FASTexeFile)

%%

