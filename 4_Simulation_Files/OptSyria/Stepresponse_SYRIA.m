%% Setup
clearvars; close all; clc
addpath(genpath('..\WetiMatlabFunctions'))

%% Copy the adequate OpenFAST version to the example folder
FASTexeFile = 'openfast_x64.exe';
SimulationName = 'OPTSyria5MW';  % CHANGE: was 'IEA-3.4-130-RWT'
% copyfile(['../',FASTexeFile],FASTexeFile);

%% Adjust initial condition
% load steady states
%load('../SteadyStatesTable_1312.mat')  % CHANGE: was '../3p4MW/3p4MW.mat'
                        % You need to create this file with your steady states

% manipulateTXT in elasto dyn. for updating steady states 
% (for loop for blade pitch)
%ManipulateTXTFile('OPTSyria5MW_ElastoDyn.dat',...  % CHANGE: filename
   % 'BlPitch1',ss.BlPitch);  % CHANGE: use your steady-state blade pitch
%ManipulateTXTFile('OPTSyria5MW_ElastoDyn.dat',...  % CHANGE: filename
   % 'RotSpeed',ss.RotSpeed);  % CHANGE: use your steady-state rotor speed
%ManipulateTXTFile('OPTSyria5MW_ElastoDyn.dat',...  % CHANGE: filename
  %  'TTDspFA',ss.TTDspFA);   % CHANGE: use your steady-state tower displacement

%% Run Step Response
dos(['openfast_x64.exe ',SimulationName,'.fst']); % CHANGE: filename
% run OpenFAST

%% Clean up
%delete(FASTexeFile)

%% plot
FB = ReadFASTbinaryIntoStruct([SimulationName,'.outb']);  % CHANGE: filename

figure('Name','Simulation results')
subplot(5,1,1)  % CHANGE: was 4,1,1 - added 5th subplot
hold on; grid on; box on
plot(FB.Time, FB.Wind1VelX)
legend('Hub height wind speed')
ylabel('m/s')

subplot(5,1,2)  % CHANGE: was 4,1,2
hold on; grid on; box on
plot(FB.Time, FB.BldPitch1)
ylabel('BldPitch1 [deg]')

subplot(5,1,3)  % CHANGE: was 4,1,3
hold on; grid on; box on
plot(FB.Time, FB.RotSpeed)
ylabel('RotSpeed [rpm]')

subplot(5,1,4)  % CHANGE: was 4,1,4
hold on; grid on; box on
plot(FB.Time, rpm2radPs(FB.RotSpeed).*80 ./ FB.Wind1VelX)
ylabel('TSR [-]')

subplot(5,1,5)  % CHANGE: was 4,1,5
hold on; grid on; box on
plot(FB.Time, FB.GenTq)
ylabel('GenTq [kNm]')
xlabel('time [s]')

linkaxes(findobj(gcf, 'Type', 'Axes'),'x')
xlim([0 120])

