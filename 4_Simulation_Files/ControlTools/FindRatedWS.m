% -----------------------------
% Script: Finds rated wind speed.
% Exercise 08 of Master Course 
% "Controller Design for Wind Turbines and Wind Farms"
% ----------------------------------
clearvars;clc;close all;
addpath(genpath('../WetiMatlabFunctions/'))
Parameter = OptSyria_Parameters;
         
%%
v_0_min                                 = 8;
v_0_max                                 = 12;
v_0                                     = v_0_min:.01:v_0_max; % [m/s] 
Omega                                   = rpm2radPs(10); % [rpm] Rated rpm
theta                                   = 0; % [deg] no pitch at rated WS

M_G                                     = Parameter.Turbine.rated_P ...
    / (Parameter.Generator.omega_g_rated  * Parameter.Generator.eta_el);


%% Brute Force Optimization       

% loop over wind speeds calculating the rotor acceleration
RotorAcceleration = NaN(size(v_0));
% lambda            = NaN(size(v_0));
% M_a               = NaN(size(v_0));

for iv_0 = 1:length(v_0)
   [RotorAcceleration(iv_0),lambda(iv_0)] = CalculateRotorAcceleration(Omega,theta,M_G,v_0(iv_0),Parameter);
end

% calculate the cost function
CostFunctionOverWindSpeed       = RotorAcceleration.^2;

% plot to visually identify v_rated
figure
subplot(211)
hold on;box on;grid on;
plot(v_0,radPs2rpm(RotorAcceleration))
plot([v_0(1) v_0(end)],[0,0])
ylabel('rotor acceleration [rpm/s]')
subplot(212)
hold on;box on;grid on;
plot(v_0,CostFunctionOverWindSpeed*radPs2rpm(1)^2)
plot([v_0(1) v_0(end)],[0,0])
ylabel('cost funtion [(rpm)^2]')
xlabel('wind speed [m/s]')

%% Optimization using fminbnd
[v_rated,Omega_dot_Sq,exitflag] = fminbnd(@(s) ...
    CalculateRotorAcceleration(Omega,theta,M_G,s,Parameter)^2,...  % Please adjust!
    v_0_min,v_0_max,optimset('Display','iter'));
fprintf('Final cost using fminbnd: %g (rad/s)^2.\n',Omega_dot_Sq)
fprintf('Rated wind speed found using fminbnd: %f m/s.\n',v_rated)


%% Rotor Acceleration Calculation
function [RotorAcceleration, lambda] = CalculateRotorAcceleration(Omega, theta, M_g, v_0, Parameter)
    % CalculateRotorAcceleration
    R                                       = Parameter.Turbine.R;
    rho                                     = Parameter.General.rho;
    r_GB                                    = Parameter.Turbine.r_GB;
    J                                       = Parameter.Turbine.J;
    % c_P                                     = Parameter.Turbine.cP_opt; 

    % get M_g if M_g is a function
    if isa(M_g, 'function_handle')
        Omega_g         = Omega*Parameter.Turbine.r_GB;
        M_g             = M_g(Omega_g,theta,Parameter);
    end

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