%% Rated M_G Calculation for Torque Controller
% M_G = Power / (rotational speed + generator efficiency)
clearvars;close all;clc;
addpath(genpath('..\WetiMatlabFunctions'))

%% load parameters
Parameter = OptSyria_Parameters();

%% Calculation

M_G_rated = Parameter.Turbine.rated_P / (Parameter.Generator.omega_g_rated  * Parameter.Generator.eta_el);
