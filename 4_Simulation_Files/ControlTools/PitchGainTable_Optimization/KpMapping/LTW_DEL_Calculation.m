% Lifetime Weighted DEL Calculation for TwrBsMyt
% for 8:4:24 m/s and 3 seeds

% setup
clearvars;close all;clc
addpath(genpath('..\WetiMatlabFunctions'))

FilterID = 'WindSpeedsBinsFilter';

% Load Statistics file 
% load("Statistics_FeedbackOnly_(0p014_8).mat")
load("Statistics_FeedbackOnly_(0p018_6).mat"); %Statistics

%%
WindSpeedBins       = 8:4:24;
nWindSpeedBins      = size(WindSpeedBins,2);

% Filter              = ProcessResults.(FilterID);

Filter = false(15,5);
for k = 1:5
    Filter(3*(k-1)+1:3*k, k) = true;
end


m                   = 4; % WoehlerExponent
k                   = 2; % Weibull Constant
A                   = 7.5; % Weibull Constant


DEL         = Statistics.DEL_4_TwrBsMyt;
DEL_PerBin  = NaN(1,nWindSpeedBins);

% if nFilters~=nWindSpeedBins
%     error(['Dimension of Filter ',FilterID,' does not fit to WindSpeedBins input.']);
% end

for iWindSpeedBin = 1:nWindSpeedBins
    DEL_ThisBin     = DEL(Filter(:,iWindSpeedBin));
    n_ThisBin       = length(DEL_ThisBin);
    Weights         = ones(n_ThisBin,1)/n_ThisBin; % equal weights
    DEL_PerBin(iWindSpeedBin) = sum(Weights.*DEL_ThisBin.^m).^(1/m);
end

Distribution        = k/A*(WindSpeedBins/A).^(k-1).*exp(-(WindSpeedBins/A).^k);
Weights             = Distribution./sum(Distribution);
LTW_DEL_PerBin      = DEL_PerBin.*Weights.^(1/m);
LTW_DEL             = sum(LTW_DEL_PerBin.^m).^(1/m);

fprintf('LifeTimeWeightedDEL: %.2f \n', LTW_DEL);