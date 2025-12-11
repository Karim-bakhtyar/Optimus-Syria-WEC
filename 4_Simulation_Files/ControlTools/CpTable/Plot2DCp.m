clearvars; close all; clc;
addpath(genpath('..\WetiMatlabFunctions'))

%% load parameters
Parameter = OptSyria_Parameters;

%% plot
targetTheta = deg2rad([-2 -1 0]);  % degrees you want to plot

lambda  = Parameter.Turbine.SS.lambda;
theta   = Parameter.Turbine.SS.theta;
c_P     = Parameter.Turbine.SS.c_P;

figure('Name','C_p')
hold on; grid on; box on;

[~, idx] = intersect(theta, targetTheta, 'stable');

for k = 1:numel(idx)
    i = idx(k);  % column index in c_P that matches this theta
    plot(lambda, c_P(:,i), ...
        'DisplayName', sprintf('\\theta = %.0f^\\circ', rad2deg(theta(i)) ));
end

xlabel('TSR [-]')
ylabel('C_p [-]')
legend('Location','northwest', 'Interpreter','tex')