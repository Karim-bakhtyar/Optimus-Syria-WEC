%% AEP Calculation Script for IEA 3.4 MW Wind Turbine
% This script calculates the Annual Energy Production (AEP) in GWh
% using power curve data and Weibull wind distribution

%% Setup
clearvars; close all; clc;

%% 1. Load Power Curve Data from Excel
% Read the Excel file containing wind speed and power data
% Adjust the filename and sheet name as needed
% excelFile = 'base.xlsx';  % Change if your file has different name/extension

% powerCurveData = readtable(excelFile);

% load("Statistics_FeedbackOnly_(0p01_4).mat"); %Statistics
load("Statistics_FeedbackOnly_(0p018_6).mat"); %Statistics

% Extract wind speed and power columns
% Adjust column names based on your Excel file structure
% windSpeed_ms = powerCurveData{:,1};  % First column: wind speed [m/s]
% power_kW = powerCurveData{:,2};      % Second column: power [kW]

windSpeed_ms = Statistics{:,1};  % First column: wind speed [m/s]
power_kW = Statistics{:,2};      % Second column: power [kW]

% Convert power to MW if needed
power_MW = power_kW / 1000;

%% 2. Define Weibull Wind Distribution Parameters
% These are typical values - adjust based on your site conditions
% Common wind classes: IEC Class I (A=10, k=2), Class II (A=8.5, k=2), Class III (A=7.5, k=2)
A_weibull = 8.5;  % Scale parameter [m/s] - average wind speed related
k_weibull = 2;    % Shape parameter [-] - typically 1.5-2.5

% Calculate mean wind speed from Weibull parameters
V_mean = A_weibull * gamma(1 + 1/k_weibull);
fprintf('Mean wind speed: %.2f m/s\n', V_mean);

%% 3. Create Fine Wind Speed Grid for Integration
V_grid = linspace(0, 24, 241);  % Wind speed grid from 0 to 30 m/s

% Interpolate power curve to fine grid
P_grid = interp1(windSpeed_ms, power_MW, V_grid, 'linear', 0);
P_grid(P_grid < 0) = 0;  % Ensure no negative power

%% 4. Calculate Weibull Probability Distribution
% Weibull PDF: f(v) = (k/A) * (v/A)^(k-1) * exp(-(v/A)^k)
f_weibull = (k_weibull/A_weibull) * (V_grid/A_weibull).^(k_weibull-1) .* ...
            exp(-(V_grid/A_weibull).^k_weibull);

%% 5. Calculate Annual Energy Production
% Hours per year
hours_per_year = 8760;

% AEP = ∫ P(v) * f(v) * hours_per_year dv
% Using trapezoidal integration
AEP_MWh = trapz(V_grid, P_grid .* f_weibull) * hours_per_year;
AEP_GWh = AEP_MWh / 1000;

% Calculate capacity factor
rated_power_MW = max(power_MW);
capacity_factor = AEP_MWh / (rated_power_MW * hours_per_year) * 100;

%% 6. Display Results
fprintf('\n========== AEP CALCULATION RESULTS ==========\n');
fprintf('Turbine: Optimus Syria 5.0 MW\n');
fprintf('Rated Power: %.2f MW\n', rated_power_MW);
fprintf('Weibull Parameters: A = %.2f m/s, k = %.2f\n', A_weibull, k_weibull);
fprintf('---------------------------------------------\n');
fprintf('Annual Energy Production (AEP): %.4f GWh/year\n', AEP_GWh);
fprintf('Capacity Factor: %.2f %%\n', capacity_factor);
fprintf('=============================================\n\n');

%% 7. Optional: Energy Production by Wind Speed Bins
% Create wind speed bins for detailed analysis
% bin_edges = 0:1:30;
% bin_centers = (bin_edges(1:end-1) + bin_edges(2:end)) / 2;
% 
% energy_by_bin = zeros(length(bin_centers), 1);
% for i = 1:length(bin_centers)
%     idx = (V_grid >= bin_edges(i)) & (V_grid < bin_edges(i+1));
%     if any(idx)
%         energy_by_bin(i) = trapz(V_grid(idx), P_grid(idx) .* f_weibull(idx)) * hours_per_year;
%     end
% end
% 
% % Find most productive wind speed range
% [max_energy, max_idx] = max(energy_by_bin);
% fprintf('Most productive wind speed bin: %.0f-%.0f m/s (%.2f MWh/year)\n', ...
%         bin_edges(max_idx), bin_edges(max_idx+1), max_energy);

%% 8. Save Results
results.AEP_GWh = AEP_GWh;
results.AEP_MWh = AEP_MWh;
results.capacity_factor = capacity_factor;
results.rated_power_MW = rated_power_MW;
results.A_weibull = A_weibull;
results.k_weibull = k_weibull;
results.V_mean = V_mean;

% save('AEP_Results_IEA3p4MW.mat', 'results');
fprintf('Results saved to: AEP_Results_IEA3p4MW.mat\n');

%% plot
% hold on; grid on
% plot(V_grid, f_weibull)
% ylabel({"Frequency";"[-]"});
% xlabel("Wind Speed [m/s]")

% plot(V_grid, P_grid)

% scatter(windSpeed_ms, power_MW);

% x = linspace(0,30);
% plot(x,wblpdf(x,7.5,2),'DisplayName','A=10, B=1')
