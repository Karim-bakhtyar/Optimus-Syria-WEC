function [Parameter] = OptSyria_Parameters(Parameter)

Parameter.General.rho = 1.225; % [kg/m^3] from OptSyria_aerodyn

% Generator values
Parameter.Generator.omega_g_min   = rpm2radPs(800); % [rad/s] from EDT FinalGeneratorParameters.xlsx
Parameter.Generator.omega_g_rated = rpm2radPs(1200); % [rad/s] from EDT FinalGeneratorParameters.xlsx, Design Parameters Sheet
Parameter.Generator.eta_el        = 0.963; % Results.xlsx, EDT sheet, line 126.

% Turbine parameters
Parameter.Turbine.cP_opt          = 0.474; % [-] Results.xlsx, main paramaters sheet, line 23. 
Parameter.Turbine.lambda_opt      = 8.50;  % [-] Results.xlsx, main paramaters sheet, line 22.
Parameter.Turbine.R               = 80; % [m]    Results.xlsx, main paramaters sheet, line 10 from rotor diameter.
Parameter.Turbine.r_GB            = 120; % [-]   Results.xlsx, gb brake coupling sheet, line 13
Parameter.Turbine.rated_P         = 5000000; % [W] 

end




%% Helper Functions
function y = radPs2rpm(u)
y = u * 60/(2*pi);
end

function y = rpm2radPs(u)
y = u * (2*pi)/60;
end