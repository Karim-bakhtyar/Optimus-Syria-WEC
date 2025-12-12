% Sprint: IEA 3.4 MW + perfect wind preview from a single point 
% lidar system.
% 
% Purpose:
% Here, we use a perfect wind preview to demonstrate that the collective
% pitch feedforward controller (designed with SLOW) is able to reduce
% significantly the rotor speed variation when OpenFAST is disturbed by an
% Extreme Operating Gust. Here, only the rotor motion and tower motion 
% (GenDOF and TwFADOF1) are enabled.  
% Result:       
% Cost for Summer Games 2025 ("30 s sprint"): 

%% Setup
clearvars;close all;clc;
addpath(genpath('..\WetiMatlabFunctions'))

% Copy the adequate OpenFAST version to the example folder
FASTexeFile     = 'openfast_x64.exe';
SimulationName  = 'IEA-3.4-130-RWT';
copyfile(['..\OpenFAST\',FASTexeFile],FASTexeFile)

%% Run FB
dos(['openfast_x64.exe ',SimulationName,'_FB.fst']);                    % run OpenFAST

% % % Run FBFF  
dos(['openfast_x64.exe ',SimulationName,'_FBFF.fst']);                  % run OpenFAST

%% Clean up
delete(FASTexeFile)

%% Comparison
% read in data
FB              = ReadFASTbinaryIntoStruct([SimulationName,'_FB.outb']);
FBFF            = ReadFASTbinaryIntoStruct([SimulationName,'_FBFF.outb']);

% Plot 
figure('Name','Simulation results')

subplot(4,1,1);
hold on; grid on; box on
plot(FB.Time,       FB.Wind1VelX);
plot(FBFF.Time,     FBFF.VLOS01LI);
legend('Hub height wind speed','Vlos')
ylabel('[m/s]');
legend('Wind1VelX','VLOS01LI')

subplot(4,1,2);
hold on; grid on; box on
plot(FB.Time,       FB.BldPitch1);
plot(FBFF.Time,     FBFF.BldPitch1);
ylabel({'BldPitch1'; '[deg]'});
legend('feedback only','feedback-feedforward')

subplot(4,1,3);
hold on; grid on; box on
plot(FB.Time,       FB.RotSpeed);
plot(FBFF.Time,     FBFF.RotSpeed);
ylabel({'RotSpeed';'[rpm]'});

subplot(4,1,4);
hold on; grid on; box on
plot(FB.Time,       FB.TwrBsMyt/1e3);
plot(FBFF.Time,     FBFF.TwrBsMyt/1e3);
ylabel({'TwrBsMyt';'[MNm]'});

xlabel('time [s]')
linkaxes(findobj(gcf, 'Type', 'Axes'),'x');
xlim([0 30])

% display results
RotSpeed_0  = 11.634;     % [rpm]
TwrBsMyt_0  = 5.656e4;  % [kNm] 
t_Start     = 0;        % [s]

% cost for feedback feedforward
Cost_FBFF = (max(abs(FBFF.RotSpeed(FBFF.Time>=t_Start)-RotSpeed_0))) / RotSpeed_0 ...
     + (max(abs(FBFF.TwrBsMyt(FBFF.Time>=t_Start)-TwrBsMyt_0))) / TwrBsMyt_0;

fprintf('Cost for feedback feedforward ("30 s sprint"):  %f \n',Cost_FBFF);

% cost for feedback only
Cost_FB = (max(abs(FB.RotSpeed(FB.Time>=t_Start)-RotSpeed_0))) / RotSpeed_0 ...
     + (max(abs(FB.TwrBsMyt(FB.Time>=t_Start)-TwrBsMyt_0))) / TwrBsMyt_0;

fprintf('Cost for feedback only ("30 s sprint"):  %f \n',Cost_FB);
