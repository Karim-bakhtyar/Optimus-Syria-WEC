clearvars; close all; clc;
addpath(genpath('..\WetiMatlabFunctions'))

%% load parameters
Parameter = OptSyria_Parameters;

%% plot
ThetaMinus2deg(:,1) = Parameter.Turbine.SS.c_P(:,1);
ThetaMinus2deg(:,2) = Parameter.Turbine.SS.lambda;

ThetaZerodeg(:,1) = Parameter.Turbine.SS.c_P(:,2);
ThetaZerodeg(:,2) = Parameter.Turbine.SS.lambda;

figure('Name','C_p')
hold on;grid on;box on;
plot(ThetaMinus2deg(:,2),ThetaMinus2deg(:,1));
plot(ThetaZerodeg(:,2),ThetaZerodeg(:,1));
xlabel('TSR [-]')
ylabel('C_p [-]')
legend('theta=-2°','theta=0°',Location='northwest')