function [Parameter] = OptSyria_Parameters(Parameter)
% General Values
Parameter.General.rho = 1.017; % [kg/m^3] Results.xlsx, site conditions.

% Turbine parameters
Parameter.Turbine.SS             	= load('PowerAndThrustCoefficients_OptSyria_1012','c_P','c_T','theta','lambda'); % from aero team, qblade 
Parameter.Turbine.cP_opt          = 0.4837; % [-] From Cp table 
Parameter.Turbine.lambda_opt      = 8.3776;  % [-] From Cp table
Parameter.Turbine.R               = 80; % [m]    Results.xlsx, main paramaters sheet, line 10 from rotor diameter.
Parameter.Turbine.r_GB            = 120; % [-]   Results.xlsx, gb brake coupling sheet, line 13
Parameter.Turbine.rated_P         = 5000000; % [W] 
J_R                               = 20358.47; % [kg m^2]; 
J_G                               = 100; % [kg m^2];
Parameter.Turbine.J               = J_R + J_G * Parameter.Turbine.r_GB^2;

% Generator values
Parameter.Generator.omega_g_min   = rpm2radPs(800); % [rad/s] from EDT FinalGeneratorParameters.xlsx
Parameter.Generator.omega_g_rated = rpm2radPs(1200); % [rad/s] from EDT FinalGeneratorParameters.xlsx, Design Parameters Sheet
Parameter.Generator.eta_el        = 0.963; % Results.xlsx, EDT sheet, line 126.
Parameter.Generator.M_G_rated = Parameter.Turbine.rated_P ...
    / (Parameter.Generator.omega_g_rated  * Parameter.Generator.eta_el);

end




%% Helper Functions
function y = radPs2rpm(u)
y = u * 60/(2*pi);
end

function y = rpm2radPs(u)
y = u * (2*pi)/60;
end