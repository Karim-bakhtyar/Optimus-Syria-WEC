%% Setup
% !!! change to 4 beam lidar
% Simulation time should be 600 seconds
% initial conditions should be for 20 m/s
% inflow wind input to TurbulentWind/URef20_seed_0x

clearvars;close all;clc;
addpath(genpath('..\WetiMatlabFunctions'))
addpath('..\ControlTools\')
Parameter = OptSyria_Parameters;

FASTexeFile     = 'openfast_x64.exe';
SimulationName  = 'OPTSyria5MW';
copyfile(['..\OpenFAST\',FASTexeFile],FASTexeFile)

%% Run FB + FBFF
% dos(['openfast_x64.exe ',SimulationName,'_FB.fst']);

% dos(['openfast_x64.exe ',SimulationName,'_FBFF.fst']);

%% Clean up
delete(FASTexeFile)

%% Read Results
FB                = ReadFASTbinaryIntoStruct([SimulationName,'_FB.outb']);
FBFF              = ReadFASTbinaryIntoStruct([SimulationName,'_FBFF.outb']);

FBFF_R             = ReadROSCOtextIntoStruct('OPTSyria5MW_FBFF.RO.dbg');

%% Plot Results
figure('Name','Simulation results')

subplot(4,1,1);
hold on; grid on; box on
plot(FB.Time,       FB.Wind1VelX);
plot(FBFF_R.Time,     FBFF_R.REWS_b);
ylabel('[m/s]');
legend('Wind1VelX','REWS_b')

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
xlim([0 660])

%% cost
% cost display results
RotSpeed_0  = 10;     % [rpm]
TwrBsMyt_0  = 7.1383e+04;  % [kNm] 
t_Start     = 60;        % [s]

% cost for feedback feedforward
Cost_FBFF = (max(abs(FBFF.RotSpeed(FBFF.Time>=t_Start)-RotSpeed_0))) / RotSpeed_0 ...
     + (max(abs(FBFF.TwrBsMyt(FBFF.Time>=t_Start)-TwrBsMyt_0))) / TwrBsMyt_0;

fprintf('Cost for feedback feedforward ("30 s sprint"):  %f \n',Cost_FBFF);

% cost for feedback only
Cost_FB = (max(abs(FB.RotSpeed(FB.Time>=t_Start)-RotSpeed_0))) / RotSpeed_0 ...
     + (max(abs(FB.TwrBsMyt(FB.Time>=t_Start)-TwrBsMyt_0))) / TwrBsMyt_0;

fprintf('Cost for feedback only ("30 s sprint"):  %f \n',Cost_FB);

%% TwrBsMyt DEL
WoehlerExponentSteel    = 4;
FB_DEL = CalculateDEL(FB.TwrBsMyt, FB.Time, WoehlerExponentSteel);
FBFF_DEL = CalculateDEL(FBFF.TwrBsMyt, FBFF.Time, WoehlerExponentSteel);
fprintf("DEL for FB only: %.2f\n", FB_DEL);
fprintf("DEL for FBFF: %.2f\n", FBFF_DEL);

%% Rotor speed Power Spectral Density
% feedback only 
dt = 0.0125;     % [s]
fs = 1/dt;       % [Hz]

StartIndex = find(FB.Time == 60, 1, 'first');
% remove mean 
rpmFB = FB.RotSpeed(StartIndex:end);
rpmFB = rpmFB - mean(rpmFB);

N  = length(rpmFB);

% Welch settings: 4 blocks 
L        = floor(N/4);      % block length so we have 4 segments
% L      = floor(L/2)*2;
window   = ones(L,1);       % rectangular window
noverlap = 0; %L/2;               % 50% overlap
nfft     = L; %max(2^nextpow2(L), L);

% PSD via Welch
[P1_FB, fw0_FB] = pwelch(rpmFB, window, noverlap, nfft, fs);  % one-sided PSD

% FB+FF
% remove mean
rpmFBFF = FBFF.RotSpeed(StartIndex:end);
rpmFBFF = rpmFBFF - mean(rpmFBFF);

N  = length(rpmFBFF);

% Welch settings: 4 blocks
L        = floor(N/4);      % block length so we have 4 segments
% L      = floor(L/2)*2;
window   = ones(L,1);       % rectangular window
noverlap = 0; %L/2;               % 50% overlap
nfft     = L; %max(2^nextpow2(L), L);

% PSD via Welch 
[P1_FBFF, fw0_FBFF] = pwelch(rpmFBFF, window, noverlap, nfft, fs);  % one-sided PSD

% plot rotor speed PSD
figure('Name','Rotor Speed PSD');
title('Rotor Speed PSD');
semilogy(fw0_FB, P1_FB);
hold on; grid on; box on;
semilogy(fw0_FBFF, P1_FBFF);
xlabel('f [Hz]');
ylabel('P_1(f) [(rpm)^2/Hz]');
% ylim([])
xlim([0 1])

%% Tower base bending PSD
% feedback only 
dt = 0.0125;     % [s]
fs = 1/dt;       % [Hz]

% remove mean 
towerFB = FB.TwrBsMyt(StartIndex:end);
towerFB = towerFB - mean(towerFB);

N  = length(towerFB);

% Welch settings: 4 blocks 
L        = floor(N/4);      % block length so we have 4 segments
% L      = floor(L/2)*2;
window   = ones(L,1);       % rectangular window
noverlap = 0; %L/2;               % 50% overlap
nfft     = L; %max(2^nextpow2(L), L);

% ---- PSD via Welch ----
[P1_FB, fw0_FB] = pwelch(towerFB, window, noverlap, nfft, fs);  % one-sided PSD

% FB+FF
% remove mean 
towerFBFF = FBFF.TwrBsMyt(StartIndex:end);
towerFBFF = towerFBFF - mean(towerFBFF);

N  = length(towerFBFF);

% Welch settings: 4 blocks
L        = floor(N/4);      % block length so we have 4 segments
% L      = floor(L/2)*2;
window   = ones(L,1);       % rectangular window
noverlap = 0; %L/2;               % 50% overlap
nfft     = L; %max(2^nextpow2(L), L);          

% ---- PSD via Welch ----
[P1_FBFF, fw0_FBFF] = pwelch(towerFBFF, window, noverlap, nfft, fs);  % one-sided PSD

% plot Tower base moment PSD
figure('Name','Tower Base Moment PSD');
title('Tower Base Moment PSD');
semilogy(fw0_FB, P1_FB);
hold on; grid on; box on;
semilogy(fw0_FBFF, P1_FBFF);
xlabel('f [Hz]');
ylabel('P_1(f) [(kNm)^2/Hz]');
xlim([0 1])

%% pitch angle PSD
% feedback only 
dt = 0.0125;     % [s]
fs = 1/dt;       % [Hz]

% remove mean 
pitchFB = FB.BldPitch1(StartIndex:end);
pitchFB = pitchFB - mean(pitchFB);

N  = length(pitchFB);

% Welch settings: 4 blocks 
L        = floor(N/4);      % block length so we have 4 segments
% L      = floor(L/2)*2;
window   = ones(L,1);       % rectangular window
noverlap = 0; %L/2;               % 50% overlap
nfft     = L; %max(2^nextpow2(L), L);

% ---- PSD via Welch ----
[P1_FB, fw0_FB] = pwelch(pitchFB, window, noverlap, nfft, fs);  % one-sided PSD

% FB+FF
% remove mean
pitchFBFF = FBFF.BldPitch1(StartIndex:end);
pitchFBFF = pitchFBFF - mean(pitchFBFF);

N  = length(pitchFBFF);

% Welch settings: 4 blocks 
L        = floor(N/4);      % block length so we have 4 segments
% L      = floor(L/2)*2;
window   = ones(L,1);       % rectangular window
noverlap = 0; %L/2;               % 50% overlap
nfft     = L; %max(2^nextpow2(L), L);

% ---- PSD via Welch ----
[P1_FBFF, fw0_FBFF] = pwelch(pitchFBFF, window, noverlap, nfft, fs);  % one-sided PSD

%plot Pitch angle PSD
figure('Name','Pitch Angle PSD');
title('Pitch Angle PSD');
semilogy(fw0_FB, P1_FB);
hold on; grid on; box on;
semilogy(fw0_FBFF, P1_FBFF);
xlabel('f [Hz]');
ylabel('P_1(f) [(deg)^2/Hz]');
xlim([0 1])

