
%% Setup
clearvars;close all;clc;
addpath(genpath('..\WetiMatlabFunctions'))

% Copy the adequate OpenFAST version to the example folder
FASTexeFile     = 'openfast_x64.exe';
SimulationName  = 'IEA-3.4-130-RWT';
copyfile(['..\OpenFAST\',FASTexeFile],FASTexeFile)

%% Adjust initial condition

% load steady states
load('..\SprintOptimus_3p4MW\SteadyStates_3p4MW.mat')

% manipulateTXT in elasto dyn. for updating steady states
    % for loop for blade pitch
    % ManipulateTXTFile('IEA-3.4-130-RWT_ElastoDyn.dat',-,-);

    % rotorspeed
    % ManipulateTXTFile('IEA-3.4-130-RWT_ElastoDyn.dat',-,-);

    % foreaft towertop displacement
    % ManipulateTXTFile('IEA-3.4-130-RWT_ElastoDyn.dat',-,-);

%% Run Step Response
dos(['openfast_x64.exe ',SimulationName,'_FB.fst']);                    % run OpenFAST

%% Clean up
delete(FASTexeFile)

%% plot
FB              = ReadFASTbinaryIntoStruct([SimulationName,'_FB.outb']);

figure('Name','Simulation results')

subplot(4,1,1);
hold on; grid on; box on
plot(FB.Time,       FB.Wind1VelX);
legend('Hub height wind speed')
ylabel('[m/s]');

subplot(4,1,2);
hold on; grid on; box on
plot(FB.Time,       FB.BldPitch1);
ylabel({'BldPitch1'; '[deg]'});

subplot(4,1,3);
hold on; grid on; box on
plot(FB.Time,       FB.RotSpeed);
ylabel({'RotSpeed';'[rpm]'});

subplot(4,1,4);
hold on; grid on; box on
plot(FB.Time,       FB.RtTSR);
ylabel({'TSR';'[-]'});

% subplot(4,1,5);
% hold on; grid on; box on
% plot(FB.Time,       FB.TwrBsMyt/1e3);
% ylabel({'TwrBsMyt';'[MNm]'});


xlabel('time [s]')
linkaxes(findobj(gcf, 'Type', 'Axes'),'x');
xlim([0 120])

% display results
RotSpeed_0  = 11.37;     % [rpm]
TwrBsMyt_0  = 56.2e3;  % [kNm] 
t_Start     = 0;        % [s]

Cost = (max(abs(FB.RotSpeed(FB.Time>=t_Start)-RotSpeed_0))) / RotSpeed_0 ...
     + (max(abs(FB.TwrBsMyt(FB.Time>=t_Start)-TwrBsMyt_0))) / TwrBsMyt_0;

fprintf('Cost for step response ("30 s sprint"):  %f \n',Cost);