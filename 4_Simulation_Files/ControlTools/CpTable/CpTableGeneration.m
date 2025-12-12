clear all; close all; clc;

%% CpTableGeneration 
% based on OptimusShakti script.

%% Open File
InputFile  = 'OptSyriaBlade_1012.txt';

%% PostProcessing QBlade Output
fid         = fopen(InputFile);
formatSpec  = repmat('%f',1,10);
Results = textscan(fid,formatSpec,'HeaderLines',7);

WIND        = Results{:,1};
ROT         = Results{:,2};
PITCH       = Results{:,3};
POWER       = Results{:,4};
THRUST      = Results{:,5};
TORQUE      = Results{:,6};
TSR         = Results{:,7};
CP          = Results{:,8};
CT          = Results{:,9};
CM          = Results{:,10};
fclose(fid);

% find unique TSR
TSR = unique(TSR)';

% find unique PITCH
PITCH = unique(PITCH)*pi/180;

% Cp table generation
% u = length(TSR)/length(unique(TSR)); 
Cp_table = reshape(CP,[length(PITCH),length(TSR)]);

% Ct table generation
% u = length(TSR)/length(unique(TSR)); 
Ct_table = reshape(CT,[length(PITCH),length(TSR)]);

% Cq table generation
% u = length(TSR)/length(unique(TSR)); 
Cq_table = reshape(CM,[length(PITCH),length(TSR)]);


%% Creating .mat file 
name = 'PowerAndThrustCoefficients_OptSyria_1012';

info    = ['Created from Qblade for the Optimus Syria with script CpTableGeneration.'];
c_P     = Cp_table';
c_T     = Ct_table';
lambda  = TSR;
theta   = PITCH;    
save(name,'info','c_P','c_T','lambda','theta')
%%
figure
surf(rad2deg(theta),lambda,c_P)
xlabel('\theta [deg]')
ylabel('\lambda')
zlabel('c_P')
title('from QBlade')

fprintf('Optimus Surface ranges:\n');
fprintf('theta min: %f\n',rad2deg(min(theta)));
fprintf('theta max: %f\n',rad2deg(max(theta)));
fprintf('lambda min: %f\n',min(lambda));
fprintf('lambda max: %f\n',max(lambda));
