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

subplot(5,1,1);
hold on; grid on; box on
plot(FB.Time,       FB.Wind1VelX);
ylabel('[m/s]');


subplot(5,1,2);
hold on; grid on; box on
plot(FB.Time,       FB.RotSpeed);
ylabel({'RotSpeed';'[rpm]'});


subplot(5,1,3);
hold on; grid on; box on
plot(FB.Time,       FB.GenTq);
ylabel({'Generator Torque';'[kNm]'});

subplot(5,1,4);
hold on; grid on; box on
plot(FB.Time,       (FB.RotSpeed .* (2*pi/60) .* 80) ./ FB.Wind1VelX); %
ylabel({'Tip Speed Ratio';'[-]'});

subplot(5,1,5);
hold on; grid on; box on
plot(FB.Time,       FB.BldPitch1); %
ylabel({'Pitch Angle';'[°]'});

xlabel('time [s]')
linkaxes(findobj(gcf, 'Type', 'Axes'),'x');
xlim([0 240])
