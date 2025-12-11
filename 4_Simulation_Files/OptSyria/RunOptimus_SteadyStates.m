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
WindSpeed = 1:1:30;
SteadyStates = zeros(length(WindSpeed), 6); % row for each speed, [WS, pitch, rotspeed, M_G, P, TTDspFA]

%% Run FB

previousWS = '1 HWindSpeed'; % initial string to start
for v_i = 1:length(WindSpeed)% loop around each wind speed
    currentWS = previousWS; % string that is currently in inflow.dat 
    replacementWS = [num2str(v_i), ' HWindSpeed']; % WS string that is going to run in this iteration

    % ManipulateTXTFile('text file you want to edit','string you want to change','new string that you want to add')
    ManipulateTXTFile('OPTSyria5MW_Inflow.dat',currentWS,replacementWS); % edit the wind speed in inflow.dat file

    dos(['openfast_x64.exe ',SimulationName,'.fst']); % run simulation

    Results              = ReadFASTbinaryIntoStruct([SimulationName,'.outb']); % read the results

    % plot
    figure('Name', ['WindSpeed ' num2str(WindSpeed(v_i))], 'NumberTitle', 'off');

    subplot(5,1,1);
    hold on; grid on; box on
    plot(Results.Time,       Results.Wind1VelX);
    ylabel('[m/s]');

    subplot(5,1,2);
    hold on; grid on; box on
    plot(Results.Time,       Results.RotSpeed);
    ylabel({'RotSpeed';'[rpm]'});

    subplot(5,1,3);
    hold on; grid on; box on
    plot(Results.Time,       Results.BldPitch1); %
    ylabel({'Pitch';'[deg]'});

    subplot(5,1,4);
    hold on; grid on; box on
    plot(Results.Time,       Results.GenTq);
    ylabel({'Generator Torque';'[kNm]'});

    subplot(5,1,5);
    hold on; grid on; box on
    plot(Results.Time,       Results.GenPwr); %
    ylabel({'Generator Power';'[W]'});

    % In order to only get settled values we should get the mean of last 3 rotations
    sProtation = 60/Results.RotSpeed(end); % seconds per rotation
    dt = Results.Time(2) - Results.Time(1);
    start_index = round((600 - 3*sProtation)/dt); % [(600 seconds) - (3*one rotation in seconds)]/dT
    
    if start_index < 0
        start_index = length(Results.Time)-1 ;
    end
    

    % Calculate steady-state average
    WS = Results.Wind1VelX(end);
    pitch = mean(Results.BldPitch1(start_index:end)); % get the mean value of blade pitch in last 3 rotations
    rotspeed = mean(Results.RotSpeed(start_index:end)); % get the mean value of RotSpeed in last 3 rotations
    M_G = mean(Results.GenTq(start_index:end));
    P = mean(Results.GenPwr(start_index:end));
    TTDspFA = mean(Results.TTDspFA(start_index:end));
    
    SteadyStates(v_i, :) = [WS, rotspeed, pitch,TTDspFA, M_G, P];

    previousWS = replacementWS; % replacing the previousWS string at the end of the iteration
end

%% Finalize and Clean up
SteadyStatesTable = array2table(SteadyStates, ...
'VariableNames', {'WS','rotspeed','pitch','TTDspFA','M_G','P'});

ManipulateTXTFile('OPTSyria5MW_Inflow.dat',replacementWS,'1 HWindSpeed');

delete(FASTexeFile)

%% save steadystates.mat file
% save("SteadyStatesTable.mat","SteadyStatesTable");
