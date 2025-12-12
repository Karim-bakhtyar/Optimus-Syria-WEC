% -----------------------------
% Script: Estimates the spectra of a FOUR Beam Lidar,
% Modified from Exercise 10 of Master Course
% "Controller Design for Wind Turbines and Wind Farms"
% ----------------------------------

%% 1. Initialization
clear all; close all; clc;
addpath(genpath('..\WetiMatlabFunctions'))

%% 2. Simulate lidar

% Generate a turbulent wind field using TurbSim
OutputFile = 'TurbulentWind/URef_20_Seed_01';
if ~exist(OutputFile,'file') % only run TurbSim if out file does not exist
    dos('TurbSim_x64.exe TurbSim2a.inp');
end

% Read the wind field into Matlab with readBLgrid.m
[velocity, y, z, nz, ny, dz, dy, dt, zHub, z1, SummVars] = ReadBLgrid(OutputFile);
R = 65;

% extract values from Summary Variables
URef = SummVars(3);

% time vector
T = size(velocity,1)*dt;
t = [0:dt:T-dt];

% coordinates in Wind-Coordinate System - FOUR BEAMS
% Cross pattern: right, left, up, down 
% x is measurement distance
x_1 = -90;
x_2 = -90;
x_3 = -90;
x_4 = -90;

y_1 = 25;   % Beam 1: right % 18.756
y_2 = 25;  % Beam 2: left
y_3 = -25;    % Beam 3: center (vertical up)
y_4 = -25;    % Beam 4: center (vertical down)

z_1 = 20;    % Beam 1: horizontal % 15.522
z_2 = -20;    % Beam 2: horizontal
z_3 = -20;   % Beam 3: up
z_4 = 20;  % Beam 4: down

% backscattered laser vector for all four beams
f_1 = norm([x_1 y_1 z_1]);
f_2 = norm([x_2 y_2 z_2]);
f_3 = norm([x_3 y_3 z_3]);
f_4 = norm([x_4 y_4 z_4]);

x_n_1 = -x_1/f_1;
x_n_2 = -x_2/f_2;
x_n_3 = -x_3/f_3;
x_n_4 = -x_4/f_4;

y_n_1 = -y_1/f_1;
y_n_2 = -y_2/f_2;
y_n_3 = -y_3/f_3;
y_n_4 = -y_4/f_4;

z_n_1 = -z_1/f_1;
z_n_2 = -z_2/f_2;
z_n_3 = -z_3/f_3;
z_n_4 = -z_4/f_4;

% extract wind from wind field for all four beams
idx_y_1 = y_1==y;
idx_z_1 = z_1==y;
u_1 = velocity(:,1,idx_y_1,idx_z_1);
v_1 = velocity(:,2,idx_y_1,idx_z_1);
w_1 = velocity(:,3,idx_y_1,idx_z_1);

idx_y_2 = y_2==y;
idx_z_2 = z_2==y;
u_2 = velocity(:,1,idx_y_2,idx_z_2);
v_2 = velocity(:,2,idx_y_2,idx_z_2);
w_2 = velocity(:,3,idx_y_2,idx_z_2);

idx_y_3 = y_3==y;
idx_z_3 = z_3==y;
u_3 = velocity(:,1,idx_y_3,idx_z_3);
v_3 = velocity(:,2,idx_y_3,idx_z_3);
w_3 = velocity(:,3,idx_y_3,idx_z_3);

idx_y_4 = y_4==y;
idx_z_4 = z_4==y;
u_4 = velocity(:,1,idx_y_4,idx_z_4);
v_4 = velocity(:,2,idx_y_4,idx_z_4);
w_4 = velocity(:,3,idx_y_4,idx_z_4);

% calculate line-of-sight wind speeds for all four beams
v_los_1 = u_1*x_n_1+v_1*y_n_1+w_1*z_n_1;
v_los_2 = u_2*x_n_2+v_2*y_n_2+w_2*z_n_2;
v_los_3 = u_3*x_n_3+v_3*y_n_3+w_3*z_n_3;
v_los_4 = u_4*x_n_4+v_4*y_n_4+w_4*z_n_4;

%% 3. Reconstruction

% estimation of u component from all four beams
u_1_est = v_los_1/x_n_1;
u_2_est = v_los_2/x_n_2;
u_3_est = v_los_3/x_n_3;
u_4_est = v_los_4/x_n_4;

% estimation of rotor-effective wind speed (average of 4 beams)
v_0L = (u_1_est+u_2_est+u_3_est+u_4_est)/4;

%% 4. Estimation of Spectrum from Data

signal = detrend(v_0L,'constant');
nBlocks = 16;
nOverlap = []; % default: nDataPerBlock/2;
SamplingFrequency = 1/dt;
nDataPerBlock = floor(size(signal,1)/nBlocks/2)*2; % should be even
nFFT = 2^nextpow2(nDataPerBlock);
vWindow = hamming(nDataPerBlock);
[S_LL_est,f_est] = pwelch(signal,vWindow,nOverlap,nFFT,SamplingFrequency);

%% 5. Definition of the Kaimal spectrum

% frequency
f_max = 1/2*1/dt;
f_min = 1/T;
df = f_min;
f = [f_min:df:f_max];

% from [IEC 61400-1 third edition 2005-08 Wind turbines - Part 1: Design requirements 2005]
L_1 = 8.1 *42;
L_2 = 2.7 *42;
L_3 = 0.66 *42;
sigma_1 = 0.16*(0.75*URef+5.6);
sigma_2 = sigma_1*0.8;
sigma_3 = sigma_1*0.5;

% Spectra
S_uu = (4*L_1/URef./((1+6*f*L_1/URef).^(5/3))*sigma_1^2);
S_vv = (4*L_2/URef./((1+6*f*L_2/URef).^(5/3))*sigma_2^2);
S_ww = (4*L_3/URef./((1+6*f*L_3/URef).^(5/3))*sigma_3^2);

% Coherence calculation parameter
kappa = 12*((f/URef).^2+(0.12/L_1).^2).^0.5;

%% 6. Analytic spectrum of rotor effective wind speed estimate (FOUR BEAMS)

% Calculate coherence between all beam pairs (6 pairs for 4 beams)
gamma_uu_12 = exp(-kappa.*sqrt((y_1-y_2)^2+(z_1-z_2)^2));
gamma_uu_13 = exp(-kappa.*sqrt((y_1-y_3)^2+(z_1-z_3)^2));
gamma_uu_14 = exp(-kappa.*sqrt((y_1-y_4)^2+(z_1-z_4)^2));
gamma_uu_23 = exp(-kappa.*sqrt((y_2-y_3)^2+(z_2-z_3)^2));
gamma_uu_24 = exp(-kappa.*sqrt((y_2-y_4)^2+(z_2-z_4)^2));
gamma_uu_34 = exp(-kappa.*sqrt((y_3-y_4)^2+(z_3-z_4)^2));

% Four-beam spectrum
% Factor 1/16 = 1/(4^2) because we average 4 beams
% Auto-spectra: 4 terms (diagonal)
% Cross-spectra: 2 times sum of 6 coherences (off-diagonal pairs)
S_LL = (1/16) * S_uu .* (4 + 2*(gamma_uu_12 + gamma_uu_13 + gamma_uu_14 + ...
                                 gamma_uu_23 + gamma_uu_24 + gamma_uu_34)) ...
       + (1/16) * S_vv * ((y_n_1/x_n_1)^2 + (y_n_2/x_n_2)^2 + ...
                          (y_n_3/x_n_3)^2 + (y_n_4/x_n_4)^2) ...
       + (1/16) * S_ww * ((z_n_1/x_n_1)^2 + (z_n_2/x_n_2)^2 + ...
                          (z_n_3/x_n_3)^2 + (z_n_4/x_n_4)^2);

%% 7. Analytic spectrum of rotor effective wind speed

R = 65;
[Y,Z] = meshgrid(-64:4:64,-64:4:64);
DistanceToHub = (Y(:).^2+Z(:).^2).^0.5;
nPoint = length(DistanceToHub);
IsInRotorDisc = DistanceToHub<=R;
nPointInRotorDisc = sum(IsInRotorDisc);

% loop over all rotor disc points
SUM_gamma_uu = zeros(size(f)); % allocation
for iPoint=1:1:nPoint % ... all iPoints
    if IsInRotorDisc(iPoint)
        for jPoint=1:1:nPoint % ... all jPoints
            if IsInRotorDisc(jPoint)
                Distance = ((Y(jPoint)-Y(iPoint))^2+(Z(jPoint)-Z(iPoint))^2)^0.5;
                gamma = exp(-kappa.*Distance);
                SUM_gamma_uu = SUM_gamma_uu + gamma;
            end
        end
    end
end

% spectra rotor-effective wind speed
S_RR = (S_uu/nPointInRotorDisc^2).*SUM_gamma_uu;

%% 8. Analytic cross-spectrum (FOUR BEAMS)

% cross-spectra rotor-effective wind speed and its lidar estimate
SUM_gamma_RL = zeros(size(f)); % allocation
for iPoint = 1:1:nPoint
    if IsInRotorDisc(iPoint)
        % Distance from rotor point i to all 4 Lidar Points
        Dist_i_L1 = sqrt((Y(iPoint) - y_1)^2 + (Z(iPoint) - z_1)^2);
        Dist_i_L2 = sqrt((Y(iPoint) - y_2)^2 + (Z(iPoint) - z_2)^2);
        Dist_i_L3 = sqrt((Y(iPoint) - y_3)^2 + (Z(iPoint) - z_3)^2);
        Dist_i_L4 = sqrt((Y(iPoint) - y_4)^2 + (Z(iPoint) - z_4)^2);

        % Sum coherences for all four beams
        SUM_gamma_RL = SUM_gamma_RL + exp(-kappa.*Dist_i_L1) + ...
                                       exp(-kappa.*Dist_i_L2) + ...
                                       exp(-kappa.*Dist_i_L3) + ...
                                       exp(-kappa.*Dist_i_L4);
    end
end

% Cross-spectrum S_RL
% Factor is 1/(4*N_rotor) because we average over N rotor points and 4 lidar points
S_RL = S_uu .* SUM_gamma_RL / (4 * nPointInRotorDisc);

%% 9. Coherence

gamma_Sq_RL = abs(S_RL).^2./(S_RR.*S_LL);
k = 2*pi*f/URef;

% Find bandwidth at 0.5 coherence (MCB = Modified Coherence Bandwidth)
target = 0.5;
[~, idx_mcb] = min( abs(gamma_Sq_RL - target) );
if isempty(idx_mcb)
    MCB = max(k); % Fallback if coherence is high everywhere
else
    MCB = k(idx_mcb);
end

% Smallest Detectable Eddy Size
SDES = (1/MCB)*2*pi/(2*R);

%% 10. Transfer function for low pass filter
Gain_RL = abs(abs(S_RL) ./ S_LL);

%% 11. Plots

% time series
figure('Name','Time Series - Four Beam Lidar')
hold all; grid on; box on
plot(t,v_los_1,'.-','DisplayName','v_{los,1} (right)')
plot(t,v_los_2,'.-','DisplayName','v_{los,2} (left)')
plot(t,v_los_3,'.-','DisplayName','v_{los,3} (up)')
plot(t,v_los_4,'.-','DisplayName','v_{los,4} (down)')
plot(t,v_0L,'.-','LineWidth',1.5,'DisplayName','v_{0L} (averaged)')
xlim([0 30])
xlabel('time [s]')
ylabel('wind speeds [m/s]')
legend('Location','best')
title('Four-Beam LiDAR Time Series')

% frequency spectra
figure('Name','Spectra - Four Beam Lidar')
hold all; grid on; box on
plot(f_est,S_LL_est,'LineWidth',1.5,'DisplayName','S_{LL,est} (from data)')
plot(f,S_LL,'LineWidth',1.5,'DisplayName','S_{LL} (4-beam model)')
plot(f,S_uu,'--','DisplayName','S_{uu} (Kaimal)')
plot(f,S_RR,'-.','DisplayName','S_{RR} (rotor-effective)')
xlim([1e-3 1e0])
set(gca,'xScale','log')
set(gca,'yScale','log')
xlabel('frequency [Hz]')
ylabel('spectra [(m/s)^2/Hz]')
legend('Location','best')
title('Power Spectral Density - Four-Beam LiDAR')

% coherence
figure('Name','Coherence - Four Beam Lidar')
hold all; grid on; box on
plot(k,gamma_Sq_RL,'LineWidth',2,'DisplayName','\gamma^2_{RL}')
plot([1e-3 1e0],[0.5 0.5],'--k','DisplayName','0.5 threshold')
plot(MCB,0.5,'ro','MarkerSize',10,'LineWidth',2,'DisplayName',sprintf('MCB = %.4f rad/m',MCB))
xlim([1e-3 1e0])
ylim([0 1])
set(gca,'xScale','log')
xlabel('wave number [rad/m]')
ylabel('coherence [-]')
legend('Location','best')
title(sprintf('Coherence - Four-Beam LiDAR (SDES = %.2f)',SDES))
grid on

% Transfer function, for low pass filter
figure('Name','Transfer Function G_RL = S_RL / S_LL')
semilogx(k,Gain_RL);
xlabel('wave number [rad/m]')
ylabel('Transfer Function [|G_RL|]')
hold all; grid on; box on


%% 12. Display Results

fprintf('\n=== FOUR-BEAM LIDAR ANALYSIS RESULTS ===\n')
fprintf('Mean wind speed (URef): %.2f m/s\n', URef)
fprintf('Rotor radius (R): %.2f m\n', R)
fprintf('\nBeam configuration:\n')
fprintf('  Beam 1 (right): x=%.1f, y=%.1f, z=%.1f m\n', x_1, y_1, z_1)
fprintf('  Beam 2 (left):  x=%.1f, y=%.1f, z=%.1f m\n', x_2, y_2, z_2)
fprintf('  Beam 3 (up):    x=%.1f, y=%.1f, z=%.1f m\n', x_3, y_3, z_3)
fprintf('  Beam 4 (down):  x=%.1f, y=%.1f, z=%.1f m\n', x_4, y_4, z_4)
fprintf('\nCoherence metrics:\n')
fprintf('  Modified Coherence Bandwidth (MCB): %.4f rad/m\n', MCB)
fprintf('  Smallest Detectable Eddy Size (SDES): %.2f (normalized by 2R)\n', SDES)
fprintf('  Max coherence: %.4f\n', max(gamma_Sq_RL))
fprintf('\n========================================\n')