%% Feedback controller team
%  script for getting steady state values of pitch and rotor speed

%% Changes you should do before running!
%  in .fst file => sim. time should be 600s, 
%  in elastodyn => only enable genDOF,TwFADOF1; no initial conditions set 
%  in inflowFile.dat => WindType=1, PLexp=0.2
%
%  don't forget check SimulationName.
%  it is running for feedback

%% Preprocess
clearvars;close all;clc;
addpath(genpath('..\WetiMatlabFunctions'))

inflowFile = "IEA-3.4-130-RWT_InflowFile"; % file that contains wind properties

FASTexeFile     = 'openfast_x64.exe';
SimulationName  = 'IEA-3.4-130-RWT';
copyfile(['..\OpenFAST\',FASTexeFile],FASTexeFile)

%Initialize a table to store the results
SteadyStates_3p4MW = table( ...
    'Size', [0, 4], ...
    'VariableTypes', {'double', 'double', 'double','double'}, ...
    'VariableNames', {'WindSpeed_ms', 'AvgBladePitch_deg', 'AvgRotorSpeed_rpm', 'TTDspFA'} ...
);

%% Process FAST for every wind speed

previousWS = '1 HWindSpeed'; % initial string to start
for WindSpeed = 3:1:25 % values between CIN and COUT WS
    currentWS = previousWS; % string that is currently in inflow.dat 
    replacementWS = [num2str(WindSpeed), ' HWindSpeed']; % WS string that is going to run in this iteration

    % ManipulateTXTFile('text file you want to edit','string you want to change','new string that you want to add')
    ManipulateTXTFile('IEA-3.4-130-RWT_InflowFile.dat',currentWS,replacementWS); % edit the wind speed in inflow.dat file

    dos(['openfast_x64.exe ',SimulationName,'_FB.fst']); % run simulation

    Results              = ReadFASTbinaryIntoStruct([SimulationName,'_FB.outb']); % read the results
    
    %In order to only get settled values we should get the mean of last 3 rotations
    rotPs = 60/Results.RotSpeed(end); % rotation per seconds
    start_index = round((600 - 3*rotPs)/0.0125); % [(600 seconds) - (3*one rotation in seconds)]/dT

    % Calculate steady-state averages
    avg_pitch = mean(Results.BldPitch1(start_index:end)); % get the mean value of blade pitch in last 60 seconds
    avg_rotspeed = mean(Results.RotSpeed(start_index:end)); % get the mean value of RotSpeed in last 60 seconds
    avg_TTDspFA = mean(Results.TTDspFA(start_index:end));

    % Create a new row of data (ws, pitch, rotspeed)
    new_row = table(Results.Wind1VelX(end), avg_pitch, avg_rotspeed, avg_TTDspFA, ...
        'VariableNames', {'WindSpeed_ms', 'AvgBladePitch_deg', 'AvgRotorSpeed_rpm', 'TTDspFA'}); % created a row for corresponding WS in iteration

    % Append the new row to the main results table
    SteadyStates_3p4MW = [SteadyStates_3p4MW; new_row]; % adding the created row at the end of the result table

    previousWS = replacementWS; % replacing the previousWS string at the end of the iteration
end
%% Clean up
delete(FASTexeFile)
