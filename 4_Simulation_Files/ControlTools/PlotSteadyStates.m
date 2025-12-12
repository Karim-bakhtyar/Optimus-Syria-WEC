%% setup
clearvars;close all;clc;
addpath(genpath('..\WetiMatlabFunctions'))

load('..\OptSyria\SteadyStatesTable.mat');
%%

for i=1:length(SteadyStatesTable.WS)
    TSR(i) = rpm2radPs(SteadyStatesTable.rotspeed(i)) * 80 / SteadyStatesTable.WS(i); 
end

%% plot

figure('Name','Omega')
hold on;grid on;box on;
plot(SteadyStatesTable.WS,SteadyStatesTable.rotspeed,'.',MarkerSize=24)
xlabel('v_0 [m/s]')
ylabel('\Omega [rpm]')

% figure('Name','TSR')
% hold on;grid on;box on;
% plot(SteadyStatesTable.WS,TSR,'.',MarkerSize=24)
% xlabel('v_0 [m/s]')
% ylabel('\TSR [-]')

figure('Name','theta')
hold on;grid on;box on;
plot(SteadyStatesTable.WS,SteadyStatesTable.pitch,'.',MarkerSize=24)
xlabel('v_0 [m/s]')
ylabel('\theta [deg]')

figure('Name','M_g')
hold on;grid on;box on;
plot(SteadyStatesTable.WS,SteadyStatesTable.M_G,'.',MarkerSize=24)
xlabel('v_0 [m/s]')
ylabel('M_g [kNm]')

figure('Name','x_T')
hold on;grid on;box on;
plot(SteadyStatesTable.WS,SteadyStatesTable.TTDspFA,'.',MarkerSize=24)
xlabel('v_0 [m/s]')
ylabel('x_T [m]')

figure('Name','P')
hold on;grid on;box on;
plot(SteadyStatesTable.WS,SteadyStatesTable.P,'.',MarkerSize=24)
xlabel('v_0 [m/s]')
ylabel('P [kW]')

figure('Name','Torque Controller')
hold on;grid on;box on;
plot(SteadyStatesTable.rotspeed,SteadyStatesTable.M_G/1e3,'-o',LineWidth=3)
xlabel('Omega [rpm]')
ylabel('M_g [kNm]')
