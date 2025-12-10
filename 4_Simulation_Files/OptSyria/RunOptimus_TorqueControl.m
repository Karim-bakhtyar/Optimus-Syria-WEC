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

%% Clean up
delete(FASTexeFile)

%% plot
FB              = ReadFASTbinaryIntoStruct([SimulationName,'.outb']);

figure('Name','Simulation results')

subplot(6,1,1);
hold on; grid on; box on
plot(FB.Time,       FB.Wind1VelX);
ylabel('[m/s]');

subplot(6,1,2);
hold on; grid on; box on
plot(FB.Time,       FB.RotSpeed);
ylabel({'RotSpeed';'[rpm]'});

subplot(6,1,3);
hold on; grid on; box on
plot(FB.Time,       (rpm2radPs(FB.RotSpeed) .* Parameter.Turbine.R) ./ FB.Wind1VelX); %
ylabel({'Tip Speed Ratio';'[-]'});

subplot(6,1,4);
hold on; grid on; box on
plot(FB.Time,       FB.GenTq);
ylabel({'Generator Torque';'[kNm]'});

subplot(6,1,5);
hold on; grid on; box on
plot(FB.Time,       FB.GenPwr); %
ylabel({'Generator Power';'[W]'});

subplot(6,1,6);
hold on; grid on; box on
plot(FB.Time,       FB.BldPitch1); %
ylabel({'Pitch';'[deg]'});

xlabel('time [s]')
linkaxes(findobj(gcf, 'Type', 'Axes'),'x');
xlim([0 600])
