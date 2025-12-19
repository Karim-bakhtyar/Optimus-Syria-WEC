%% Generating the Kp vectors for mapping optimization
%  searching the point where DEL is min and such that AEP is stays max.
clearvars;close all;clc;
addpath(genpath('..\..\..\WetiMatlabFunctions'))

%% Get Kp vector

[~, theta_v] = read_line_parsed('ROSCO_FB.IN', 40);
[BaseKpString, base_kp] = read_line_parsed('ROSCO_FB.IN', 41);
[BaseKiString, base_ki] = read_line_parsed('ROSCO_FB.IN', 42);

theta_v = rad2deg(theta_v);

%%
%constants
rpm = 10; 
Ti = 60 / rpm2radPs(rpm); % [s] equal to 1p

% inputs
Kp = [-10e-3 -12e-3 -14e-3 -16e-3 -18e-3 ];
theta_k = [6 8 10]; 

% outputs

for i = 1:length(Kp)

    for j = 1:length(theta_k)

        for k = 1:length(theta_v)
            Kp_v(k) = Kp(i) * ( 1 / (1 + (theta_v(k)/theta_k(j))) );
            Ki_v(k) = Kp_v(k) / Ti;

            FinalV{i, j} = [Kp_v; Ki_v];
        end

    end

end

%% save ROSCO.in files
% for i= 1:length(Kp)
%     for j = 1:length(theta_k)
%         % copy and rename ROSCO.IN for corresponding point e.g. ROSCO_(-12e-3,6)
%         src  = 'ROSCO_FB.IN';             % Base
%         kstr = strrep(sprintf('%.6g', Kp(i)), '.', 'p');        % e.g., -0.0076 -> -0p0076
%         tstr = strrep(sprintf('%.6g', theta_k(j)), '.', 'p');   % e.g., 0.178 -> 0p178
%         dest = sprintf('ROSCO_Kp_%s_theta_%s.IN', kstr, tstr);
%         copyfile(src, dest);                                    % returns 1 on success, 0 on failure
% 
%         % use manipulateTXTfile for updating Kp vector, line 41
%         row = FinalV{i,j}(1,:);                                % 1×N numeric
%         nums = strjoin(compose('%.6g', row), ' ');             % "v1 v2 v3 ..."
%         NewKpString = sprintf('%s  ! PC_GS_KP - Gain-schedule table: pitch controller kp gains [s].', nums);
%         ManipulateTXTFile(dest,BaseKpString,NewKpString); 
% 
%         % use manipulateTXTfile for updating Ki vector, line 42
%         row = FinalV{i,j}(2,:);                                % 1×N numeric
%         nums = strjoin(compose('%.6g', row), ' ');             % "v1 v2 v3 ..."
%         NewKiString = sprintf('%s  ! PC_GS_KI		- Gain-schedule table: pitch controller ki gains [-].', nums);
%         ManipulateTXTFile(dest,BaseKiString,NewKiString);
%     end
% end
% 

% ManipulateTXTFile(TXTFile,StringToReplace,NewString) 
% don't forget to add to the new string ! PC_GS_KP		- Gain-schedule table: pitch controller kp gains [s].

%% plot

% plot Kp
figure(1)
hold on; grid on; box on
for i=1:3
    for j=1:3
        plot(theta_v, FinalV{i,j}(1,:), LineWidth=1.5)
    end
end
ylabel({"Kp values";"[s]"});
xlabel("Pitch Angles [deg]")

% plot Ki
figure(2)
hold on; grid on; box on
for i=1:3
    for j=1:3
        plot(theta_v, FinalV{i,j}(2,:), LineWidth=1.5)
    end
end
ylabel({"Ki values";"[-]"});
xlabel("Pitch Angles [deg]")


%%
% figure(1)
% hold on; grid on; box on
%     for j=1:5
%         plot(theta_v, FinalV{j,1}(1,:), LineWidth=1.5)
%     end
% 
% 
% figure(2)
% hold on; grid on; box on
%     for j=1:5
%         plot(theta_v, FinalV{j,2}(1,:), LineWidth=1.5)
%     end
% 
% figure(3)
% hold on; grid on; box on
%     for j=1:5
%         plot(theta_v, FinalV{j,3}(1,:), LineWidth=1.5)
%     end
% 
% figure(4)
% hold on; grid on; box on
%     for j=1:5
%         plot(theta_v, FinalV{j,4}(1,:), LineWidth=1.5)
%     end
% 
% figure(5)
% hold on; grid on; box on
%     for j=1:5
%         plot(theta_v, FinalV{j,5}(1,:), LineWidth=1.5)
%     end


%% functions

function [lineStr, nums] = read_line_parsed(fn, n)
    % Read the nth line (space/tab-separated), return the raw line (string)
    % and a numeric parse of its whitespace-delimited fields.
    fid = fopen(fn, 'r');
    assert(fid > 0, "Cannot open file: %s", fn);
    c = onCleanup(@() fclose(fid));

    % Stream to line n
    for k = 1:n-1
        t = fgetl(fid);
        if ~ischar(t), error("File ended before line %d.", n); end
    end

    % Target line
    line = fgetl(fid);
    if ~ischar(line), error("File ended before line %d.", n); end
    lineStr = string(strtrim(line));   % return as scalar string, trimmed

    % Parse to numbers (whitespace-collapsing split)
    tokens = regexp(line, '\S+', 'match');  % internal only
    nums   = str2double(tokens);            % NaN for non-numeric tokens
    nums = nums(~isnan(nums));
end





