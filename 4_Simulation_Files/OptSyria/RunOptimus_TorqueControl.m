%% Setup
clearvars;close all;clc;
addpath(genpath('..\WetiMatlabFunctions'))
addpath('..\ControlTools\')
Parameter = OptSyria_Parameters;

FASTexeFile     = 'openfast_x64.exe';
SimulationName  = 'OPTSyria5MW';
copyfile(['..\OpenFAST\',FASTexeFile],FASTexeFile)

%% Run FB
dos(['openfast_x64.exe ',SimulationName,'.fst']);

%% Read Results
Results              = ReadFASTbinaryIntoStruct([SimulationName,'.outb']);

%% Plot Results
figure('Name','Simulation results')

subplot(7,1,1);
hold on; grid on; box on
plot(Results.Time,       Results.Wind1VelX);
ylabel('[m/s]');

subplot(7,1,2);
hold on; grid on; box on
plot(Results.Time,       Results.RotSpeed);
ylabel({'RotSpeed';'[rpm]'});

subplot(7,1,3);
hold on; grid on; box on
plot(Results.Time,       (rpm2radPs(Results.RotSpeed) .* Parameter.Turbine.R) ./ Results.Wind1VelX); %
ylabel({'Tip Speed Ratio';'[-]'});

subplot(7,1,4);
hold on; grid on; box on
plot(Results.Time,       Results.GenTq);
ylabel({'Generator Torque';'[kNm]'});

subplot(7,1,5);
hold on; grid on; box on
plot(Results.Time,       Results.GenPwr);
ylabel({'Generator Power';'[W]'});

subplot(7,1,6);
hold on; grid on; box on
plot(Results.Time,       Results.BldPitch1);
ylabel({'Pitch';'[deg]'});

subplot(7,1,7);
hold on; grid on; box on
plot(Results.Time,       Results.TTDspFA);
ylabel({'TTDspFA';'[m]'});

xlabel('time [s]')
linkaxes(findobj(gcf, 'Type', 'Axes'),'x');
xlim([0 600])

