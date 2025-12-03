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
% plot(FBFF.Time,     FBFF.VLOS01LI);
legend('Hub height wind speed','Vlos')
ylabel('[m/s]');
legend('Wind1VelX','VLOS01LI')

subplot(4,1,2);
hold on; grid on; box on
plot(FB.Time,       FB.BldPitch1);
% plot(FBFF.Time,     FBFF.BldPitch1);
ylabel({'BldPitch1'; '[deg]'});
legend('feedback only','feedback-feedforward')

subplot(4,1,3);
hold on; grid on; box on
plot(FB.Time,       FB.RotSpeed);
% plot(FBFF.Time,     FBFF.RotSpeed);
ylabel({'RotSpeed';'[rpm]'});

subplot(4,1,4);
hold on; grid on; box on
plot(FB.Time,       FB.TwrBsMyt/1e3);
% plot(FBFF.Time,     FBFF.TwrBsMyt/1e3);
ylabel({'TwrBsMyt';'[MNm]'});

xlabel('time [s]')
linkaxes(findobj(gcf, 'Type', 'Axes'),'x');
xlim([0 600])
