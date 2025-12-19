% -----------------------------
% Script: Finds rated wind speed.
% Exercise 08 of Master Course 
% "Controller Design for Wind Turbines and Wind Farms"
% ----------------------------------
clearvars;clc;close all;
Parameter.General.rho                   = 1.017;
Parameter.Turbine.r_GB                  = 120;
Parameter.Turbine.R                     = 80;
Parameter.Turbine.SS                    = load('PowerAndThrustCoefficientsOptSyria_FAST.mat');
Parameter.Turbine.J                     = 119059976+Parameter.Turbine.r_GB^2*534.116;
Parameter.Turbine.eta_el                = 0.963;
Parameter.Turbine.eta_GB                = 0.975;
v_0_min                                 = 8;
v_0_max                                 = 12;  
v_0                                     = v_0_min:.1:v_0_max; % [m/s]      
Omega                                   = rpm2radPs(10);
theta                                   = 0;  
M_g                                     = 5e6/Parameter.Turbine.eta_el/Omega/Parameter.Turbine.r_GB;
        
%% Brute Force Optimization       

% loop over wind speeds calculating the rotor acceleration
RotorAcceleration               = NaN(size(v_0));
for  iv_0 = 1:length(v_0)        
    RotorAcceleration(iv_0)     = CalculateRotorAcceleration(Omega,theta,M_g,v_0(iv_0),Parameter); 
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
    (CalculateRotorAcceleration(Omega,theta,M_g,s,Parameter))^2,...
    v_0_min,v_0_max,optimset('Display','iter'));
fprintf('Final cost using fminbnd: %g (rad/s)^2.\n',Omega_dot_Sq)
fprintf('Rated wind speed found using fminbnd: %f m/s.\n',v_rated)

%% Optimization using fminunc
[v_rated,Omega_dot_Sq,exitflag] = fminunc(@(s) ...
    (CalculateRotorAcceleration(Omega,theta,M_g,s,Parameter))^2,...
    v_0_min,optimset('Display','iter'));
fprintf('Final cost using fminunc: %g (rad/s)^2.\n',Omega_dot_Sq)
fprintf('Rated wind speed found using fminunc: %f m/s.\n',v_rated)