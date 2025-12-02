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

FBFF_R          = ReadROSCOtextIntoStruct( [SimulationName,'_FBFF.RO.dbg']);


%% Plot 
figure('Name','Simulation results')

subplot(4,1,1);
hold on; grid on; box on
plot(FB.Time,       FB.Wind1VelX);
plot(FBFF_R.Time,     FBFF_R.REWS_b);
legend('Hub height wind speed','Vlos')
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

%% Rotor speed Power Spectral Density
% feedback only 
dt = 0.0125;     % [s]
fs = 1/dt;       % [Hz]

% remove mean 
rpmFB = FB.RotSpeed;
rpmFB = rpmFB - mean(rpmFB);

N  = length(rpmFB);

% Welch settings: 4 blocks 
L        = floor(N/4);      % block length so we have 4 segments
L = floor(L/2)*2;
window   = ones(L,1);       % rectangular window
noverlap = L/2;               % 50% overlap
nfft     = max(2^nextpow2(L), L); 

% PSD via Welch
[P1_FB, fw0_FB] = pwelch(rpmFB, window, noverlap, nfft, fs);  % one-sided PSD

% FB+FF
% remove mean
rpmFBFF = FBFF.RotSpeed;
rpmFBFF = rpmFBFF - mean(rpmFBFF);

N  = length(rpmFBFF);

% Welch settings: 4 blocks
L        = floor(N/4);      % block length so we have 4 segments
L = floor(L/2)*2;
window   = ones(L,1);       % rectangular window
noverlap = L/2;               % 50% overlap
nfft     = max(2^nextpow2(L), L);

% PSD via Welch 
[P1_FBFF, fw0_FBFF] = pwelch(rpmFBFF, window, noverlap, nfft, fs);  % one-sided PSD

% plot rotor speed PSD
figure;
semilogy(fw0_FB, P1_FB);
hold on; grid on; box on;
semilogy(fw0_FBFF, P1_FBFF);
xlabel('f [Hz]');
ylabel('P_1(f) [(rpm)^2/Hz]');
xlim([0 1])

%% Tower base bending PSD
% feedback only 
dt = 0.0125;     % [s]
fs = 1/dt;       % [Hz]

% remove mean 
towerFB = FB.TwrBsMyt;
towerFB = towerFB - mean(towerFB);

N  = length(towerFB);

% Welch settings: 4 blocks 
L        = floor(N/4);      % block length so we have 4 segments
L = floor(L/2)*2;
window   = ones(L,1);       % rectangular window
noverlap = L/2;               % 50% overlap
nfft     = max(2^nextpow2(L), L); 

% ---- PSD via Welch ----
[P1_FB, fw0_FB] = pwelch(towerFB, window, noverlap, nfft, fs);  % one-sided PSD

% FB+FF
% remove mean 
towerFBFF = FBFF.TwrBsMyt;
towerFBFF = towerFBFF - mean(towerFBFF);

N  = length(towerFBFF);

% Welch settings: 4 blocks
L        = floor(N/4);      % block length so we have 4 segments
L = floor(L/2)*2;
window   = ones(L,1);       % rectangular window
noverlap = L/2;               % 50% overlap
nfft     = max(2^nextpow2(L), L);              

% ---- PSD via Welch ----
[P1_FBFF, fw0_FBFF] = pwelch(towerFBFF, window, noverlap, nfft, fs);  % one-sided PSD

% plot Tower base moment PSD
figure;
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
pitchFB = FB.BldPitch1;
pitchFB = pitchFB - mean(pitchFB);

N  = length(pitchFB);

% Welch settings: 4 blocks 
L        = floor(N/4);      % block length so we have 4 segments
L = floor(L/2)*2;
window   = ones(L,1);       % rectangular window
noverlap = L/2;               % 50% overlap
nfft     = max(2^nextpow2(L), L);

% ---- PSD via Welch ----
[P1_FB, fw0_FB] = pwelch(pitchFB, window, noverlap, nfft, fs);  % one-sided PSD

% FB+FF
% remove mean
pitchFBFF = FBFF.BldPitch1;
pitchFBFF = pitchFBFF - mean(pitchFBFF);

N  = length(pitchFBFF);

% Welch settings: 4 blocks
L        = floor(N/4);      % block length so we have 4 segments
L = floor(L/2)*2;
window   = ones(L,1);       % rectangular window
noverlap = L/2;               % 50% overlap
nfft     = max(2^nextpow2(L), L);

% ---- PSD via Welch ----
[P1_FBFF, fw0_FBFF] = pwelch(pitchFBFF, window, noverlap, nfft, fs);  % one-sided PSD

%plot Pitch angle PSD
figure;
semilogy(fw0_FB, P1_FB);
hold on; grid on; box on;
semilogy(fw0_FBFF, P1_FBFF);
xlabel('f [Hz]');
ylabel('P_1(f) [(deg)^2/Hz]');
xlim([0 1])