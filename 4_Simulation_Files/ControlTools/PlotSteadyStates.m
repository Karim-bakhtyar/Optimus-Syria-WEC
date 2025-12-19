%% setup
clearvars;close all;clc;
addpath(genpath('..\WetiMatlabFunctions'))

load('..\OptSyria\SteadyStatesTable_Final.mat');
% load('SteadyStates_ThetaMinusOne.mat');
%%

for i=1:length(SteadyStatesTable.mean_Wind1VelX)
    TSR(i) = rpm2radPs(SteadyStatesTable.mean_RotSpeed(i)) * 80 / SteadyStatesTable.mean_Wind1VelX(i); 
end

%% plot

figure('Name','Omega')
hold on;grid on;box on;
plot(SteadyStatesTable.mean_Wind1VelX,SteadyStatesTable.mean_RotSpeed,'.',MarkerSize=24)
xlabel('v_0 [m/s]')
ylabel('\Omega [rpm]')

ax = gca;
xmin = 2*ceil(ax.XLim(1)/2);
xmax = 2*floor(ax.XLim(2)/2);
xticks(ax, xmin:2:xmax);

% figure('Name','TSR')
% hold on;grid on;box on;
% plot(SteadyStatesTable.WS,TSR,'.',MarkerSize=24)
% xlabel('v_0 [m/s]')
% ylabel('\TSR [-]')

figure('Name','theta')
hold on;grid on;box on;
plot(SteadyStatesTable.mean_Wind1VelX,SteadyStatesTable.mean_BldPitch1,'.',MarkerSize=24)
xlabel('v_0 [m/s]')
ylabel('\theta [deg]')

ax = gca;
xmin = 2*ceil(ax.XLim(1)/2);
xmax = 2*floor(ax.XLim(2)/2);
xticks(ax, xmin:2:xmax);

figure('Name','M_g')
hold on;grid on;box on;
plot(SteadyStatesTable.mean_Wind1VelX,SteadyStatesTable.("M_G [kNm]"),'.',MarkerSize=24)
xlabel('v_0 [m/s]')
ylabel('M_g [kNm]')

ax = gca;
xmin = 2*ceil(ax.XLim(1)/2);
xmax = 2*floor(ax.XLim(2)/2);
xticks(ax, xmin:2:xmax);

figure('Name','x_T')
hold on;grid on;box on;
plot(SteadyStatesTable.mean_Wind1VelX,SteadyStatesTable.TTDspFA,'.',MarkerSize=24)
xlabel('v_0 [m/s]')
ylabel('x_T [m]')

ax = gca;
xmin = 2*ceil(ax.XLim(1)/2);
xmax = 2*floor(ax.XLim(2)/2);
xticks(ax, xmin:2:xmax);

figure('Name','P')
hold on;grid on;box on;
plot(SteadyStatesTable.mean_Wind1VelX,SteadyStatesTable.("P[kW]"),'.',MarkerSize=24)
xlabel('v_0 [m/s]')
ylabel('P [kW]')

ax = gca;
xmin = 2*ceil(ax.XLim(1)/2);
xmax = 2*floor(ax.XLim(2)/2);
xticks(ax, xmin:2:xmax);

figure('Name','Torque Controller')
hold on;grid on;box on;
plot(SteadyStatesTable.mean_RotSpeed,SteadyStatesTable.("M_G [kNm]"),'-o',LineWidth=3)
xlabel('Omega [rpm]')
ylabel('M_g [kNm]')

ax = gca;
xmin = 2*ceil(ax.XLim(1)/2);
xmax = 2*floor(ax.XLim(2)/2);
xticks(ax, xmin:2:xmax);

