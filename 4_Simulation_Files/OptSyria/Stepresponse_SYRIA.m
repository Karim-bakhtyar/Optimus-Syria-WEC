%% Setup
clearvars; close all; clc
addpath(genpath('..'))

%% Copy the adequate OpenFAST version to the example folder
FASTexeFile = 'openfast_x64.exe';
SimulationName = 'OPTSyria5MW';  % CHANGE: was 'IEA-3.4-130-RWT'
%copyfile(['../',FASTexeFile],FASTexeFile);

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
yline(12.1, '--r', 'Rated Speed');  % ADD: reference line for 5MW rated speed
ylabel('RotSpeed [rpm]')

subplot(5,1,4)  % CHANGE: was 4,1,4
hold on; grid on; box on
plot(FB.Time, FB.RtTSR)
yline(8.5, '--r', 'Optimal TSR');  % ADD: reference line for optimal TSR
ylabel('TSR [-]')

subplot(5,1,5)  % CHANGE: was 4,1,5
hold on; grid on; box on
plot(FB.Time, FB.TwrBsMyt/1e3)
ylabel('TwrBsMyt [MNm]')
xlabel('time [s]')

linkaxes(findobj(gcf, 'Type', 'Axes'),'x')
xlim([0 120])

%% display results
RotSpeed0 = 12.1;       % CHANGE: was 11.37 rpm (5MW rated speed)
TwrBsMyt0 = 96.2e3;     % CHANGE: was 56.2e3 kNm (estimate for 5MW)
tStart = 0;             % s

Cost = max(abs(FB.RotSpeed(FB.Time>tStart)-RotSpeed0))/RotSpeed0 + ...
       max(abs(FB.TwrBsMyt(FB.Time>tStart)-TwrBsMyt0))/TwrBsMyt0;
   
fprintf('Cost for step response >30 s: %s\n',sprintf('%f',Cost))
