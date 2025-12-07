%% Setup
clearvars;close all;clc;
addpath(genpath('..\WetiMatlabFunctions'))

FASTexeFile     = 'openfast_x64.exe';
SimulationName  = 'OPTSyria5MW';
copyfile(['..\OpenFAST\',FASTexeFile],FASTexeFile)

%% Run FB
dos(['openfast_x64.exe ',SimulationName,'.fst']);

%% Clean up
delete(FASTexeFile)
FB              = ReadFASTbinaryIntoStruct([SimulationName,'.outb']);

figure('Name','Simulation results')

subplot(4,1,1);
hold on; grid on; box on
plot(FB.Time,       FB.Wind1VelX);
ylabel('[m/s]');


subplot(4,1,2);
hold on; grid on; box on
plot(FB.Time,       FB.RotSpeed);
ylabel({'RotSpeed';'[rpm]'});


subplot(4,1,3);
hold on; grid on; box on
plot(FB.Time,       FB.GenTq);
ylabel({'Generator Torque';'[kNm]'});

subplot(4,1,4);
hold on; grid on; box on
plot(FB.Time,       (FB.RotSpeed*80*(2*pi/60))./(FB.Wind1VelX));
ylabel({'Tip Speed Ratio';'[-]'});

xlabel('time [s]')
linkaxes(findobj(gcf, 'Type', 'Axes'),'x');
xlim([0 240])
