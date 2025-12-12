%% Reference Height calculation for inflow
% sin(Shaft Tilt) * OverHang + TowerHeight + Tower to Shaft

clearvars;close all;clc;
addpath(genpath('..\WetiMatlabFunctions'))

% all values from ElastoDyn
TowerHt = 98; % [m]
Twr2Shft = 1.96256; % [m]
ShftTilt = -6; % [deg]
OverHang = -4.05; %[m]

HH = sind(ShftTilt)*OverHang + TowerHt + Twr2Shft;