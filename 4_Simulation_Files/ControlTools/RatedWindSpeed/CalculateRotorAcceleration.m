% Function: Calculates the rotor acceleration of the SLOW model.
function RotorAcceleration   = CalculateRotorAcceleration(Omega,theta,M_g,v_0,Parameter)

% get M_g if M_g is a function
if isa(M_g, 'function_handle')
    Omega_g         = Omega*Parameter.Turbine.r_GB;
    M_g             = M_g(Omega_g,theta,Parameter);
end

% get M_a
M_a                 = CalculateAerodynamicTorque(Omega,theta,v_0,Parameter);

RotorAcceleration   = 1/Parameter.Turbine.J*...
    ( M_a*Parameter.Turbine.eta_GB - M_g*Parameter.Turbine.r_GB);  
end

function M_a = CalculateAerodynamicTorque(Omega,theta,v_0,Parameter)
    lambda      = Omega*Parameter.Turbine.R/(v_0);
    if theta==0 
        c_P_0   = Parameter.Turbine.SS.c_P(:,find(Parameter.Turbine.SS.theta==0));
        c_P     = interp1(Parameter.Turbine.SS.lambda,c_P_0,lambda,'linear','extrap');
    else
        c_P     = interp2(Parameter.Turbine.SS.theta,Parameter.Turbine.SS.lambda,Parameter.Turbine.SS.c_P,theta,lambda);
    end
    M_a         = (1/2*pi*Parameter.Turbine.R^3*Parameter.General.rho*c_P/lambda*(v_0)^2);
end