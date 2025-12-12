%% K calculation from theory
% M_g = k * omega_g^2
% k = 0.5 * rho * R^5 * (cP_opt / lambda_opt^3*r_GB^3 )
clearvars; close all; clc;
addpath(genpath('..\WetiMatlabFunctions'))

%% load parameters
Parameter = OptSyria_Parameters;

%% k equation
k = (Parameter.General.rho * pi * Parameter.Turbine.R^5 * Parameter.Turbine.cP_opt)...
/ (2 * Parameter.Turbine.lambda_opt^3 * Parameter.Turbine.r_GB^3);       % [Nm/(rad/s)^2]   
