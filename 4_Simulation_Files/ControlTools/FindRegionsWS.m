% -----------------------------
% Script: Finds wind speeds where transitions between regions occur.
% Exercise 08 of Master Course 
% "Controller Design for Wind Turbines and Wind Farms"
% ----------------------------------
clearvars;clc;close all;
addpath(genpath('../WetiMatlabFunctions/'))
Parameter = OptSyria_Parameters;

rpm_min = rpm2radPs(Parameter.Generator.omega_g_min);
rpm_max = rpm2radPs(Parameter.Generator.omega_g_rated);
theta_min = 0;
k = 2.4921; % [Nm/(rad/s)^2]
r_GB = Parameter.Turbine.r_GB;

%% v_1to1d5      
v_0_min                                 = 1.0;
v_0_max                                 = 6.0; 
v_0                                     = v_0_min:.1:v_0_max; % [m/s]      
Omega                                   = rpm_min; % Please adjust!
theta                                   = theta_min; % Please adjust!
M_g                                     = 0; % Please adjust!

% Brute Force Optimization
RotorAcceleration = NaN(1,length(v_0));
for  iv_0 = 1:length(v_0)        
    RotorAcceleration(iv_0) = CalculateRotorAcceleration(Omega,theta,M_g,v_0(iv_0), Parameter); 
end        

figure
hold on;hold on;grid on;
plot(v_0,radPs2rpm(RotorAcceleration))
plot([v_0(1) v_0(end)],[0,0])
xlabel('wind speed [m/s]')
ylabel('rotor acceleration [rpm/s]')

% Optimization using fminbnd v_1to1d5
[v_1to1d5,Omega_dot_Sq,exitflag] = fminbnd(@(s) ...
    CalculateRotorAcceleration(Omega,theta,M_g,s,Parameter)^2,...  % Please adjust!
    v_0_min,v_0_max,optimset('Display','iter'));

fprintf('Final cost using fminbnd: %g (rad/s)^2.\n',Omega_dot_Sq)
fprintf('Wind speed changing region 1 -> 1.5 found using fminbnd: %f m/s.\n',v_1to1d5)

%% v_1d5to2      
v_0_min                                 = 5.0;
v_0_max                                 = 9.0; 
v_0                                     = v_0_min:.1:v_0_max; % [m/s] 
Omega                                   = rpm_min; % Please adjust!
theta                                   = theta_min; % Please adjust!
M_g                                     = k * (r_GB * Omega)^2; % Please adjust!

% Brute Force Optimization
RotorAcceleration = NaN(1,length(v_0));
for  iv_0 = 1:length(v_0)        
    RotorAcceleration(iv_0) = CalculateRotorAcceleration(Omega,theta,M_g,v_0(iv_0), Parameter); 
end        

figure
hold on;hold on;grid on;
plot(v_0,radPs2rpm(RotorAcceleration))
plot([v_0(1) v_0(end)],[0,0])
xlabel('wind speed [m/s]')
ylabel('rotor acceleration [rpm/s]')

% Optimization using fminbnd v_1to1d5
[v_1d5to2,Omega_dot_Sq,exitflag] = fminbnd(@(s) ...
    CalculateRotorAcceleration(Omega,theta,M_g,s,Parameter)^2,...  % Please adjust!
    v_0_min,v_0_max,optimset('Display','iter'));

fprintf('Final cost using fminbnd: %g (rad/s)^2.\n',Omega_dot_Sq)
fprintf('Wind speed changing region 1.5 -> 2 found using fminbnd: %f m/s.\n',v_1d5to2)

%% v_2to2d5      
v_0_min                                 = 7.0;
v_0_max                                 = 14.0;
v_0                                     = v_0_min:.1:v_0_max; % [m/s]  
Omega                                   = rpm_max; % Please adjust!
theta                                   = theta_min; % Please adjust!
M_g                                     = k * (r_GB * Omega)^2; % Please adjust!

% Brute Force Optimization
RotorAcceleration = NaN(1,length(v_0));
for  iv_0 = 1:length(v_0)        
    RotorAcceleration(iv_0) = CalculateRotorAcceleration(Omega,theta,M_g,v_0(iv_0),Parameter); 
end        

figure
hold on;hold on;grid on;
plot(v_0,radPs2rpm(RotorAcceleration))
plot([v_0(1) v_0(end)],[0,0])
xlabel('wind speed [m/s]')
ylabel('rotor acceleration [rpm/s]')

% Optimization using fminbnd v_1to1d5
[v_2to2d5,Omega_dot_Sq,exitflag] = fminbnd(@(s) ...
    CalculateRotorAcceleration(Omega,theta,M_g,s,Parameter)^2,...  % Please adjust!
    v_0_min,v_0_max,optimset('Display','iter'));

fprintf('Final cost using fminbnd: %g (rad/s)^2.\n',Omega_dot_Sq)
fprintf('Wind speed changing region 2 -> 2.5 found using fminbnd: %f m/s.\n',v_2to2d5)

%% Rotor Acceleration Calculation
function [RotorAcceleration, lambda] = CalculateRotorAcceleration(Omega, theta, M_g, v_0, Parameter)
    % CalculateRotorAcceleration
    R                                       = Parameter.Turbine.R;
    rho                                     = Parameter.General.rho;
    r_GB                                    = Parameter.Turbine.r_GB;
    J                                       = Parameter.Turbine.J;
    % c_P                                     = Parameter.Turbine.cP_opt; 

    % get M_g if M_g is a function
    % if isa(M_g, 'function_handle')
    %     Omega_g         = Omega*Parameter.Turbine.r_GB;
    %     M_g             = M_g(Omega_g,theta,Parameter);
    % end

    lambda = Omega * R / v_0;
    
    if theta==0 
        c_P_0   = Parameter.Turbine.SS.c_P(:,find(Parameter.Turbine.SS.theta==0));
        c_P     = interp1(Parameter.Turbine.SS.lambda,c_P_0,lambda,'linear','extrap');
    else
        c_P     = interp2(Parameter.Turbine.SS.theta,Parameter.Turbine.SS.lambda,Parameter.Turbine.SS.c_P,theta,lambda);
    end

    M_a    = 0.5 * rho * pi * R^3 * c_P / lambda * v_0^2;
    RotorAcceleration = (1/J) * (M_a -  M_g * r_GB);
end