function results = optimizeT_buffer(T_buffer_range, config, round_num)
    %% Optimize T_buffer parameter using real OpenFAST simulations
    % Performs brute force optimization over T_buffer range
    
    fprintf('Starting T_buffer optimization Round %d\n', round_num);
    fprintf('T_buffer range: %.3f to %.3f s (%d points)\n', ...
        min(T_buffer_range), max(T_buffer_range), length(T_buffer_range));
    
    % Initialize results
    num_points = length(T_buffer_range);
    results = struct();
    results.T_buffer = T_buffer_range;
    results.cost = zeros(size(T_buffer_range));
    results.power = zeros(size(T_buffer_range));
    results.loads = zeros(size(T_buffer_range));
    results.simulation_time = zeros(size(T_buffer_range));
    
    % Progress tracking
    start_time = tic;
    
    for i = 1:num_points
        T_buffer = T_buffer_range(i);
        
        fprintf('  Testing T_buffer = %.3f s (%d/%d)... ', T_buffer, i, num_points);
        iter_start = tic;
        
        try
            % Update Wrapper.IN with current T_buffer
            updateWrapperIN(T_buffer, config);
            
            % Run OpenFAST simulations for multiple wind speeds
            [power_metrics, load_metrics] = runOpenFASTOptimization(T_buffer, config);
            
            % Calculate cost function
            cost = calculateCostFunction(power_metrics, load_metrics, config);
            
            % Store results
            results.cost(i) = cost;
            results.power(i) = power_metrics.AEP;
            results.loads(i) = load_metrics.DEL_total;
            results.simulation_time(i) = toc(iter_start);
            
            fprintf('Cost = %.4f (%.1f s)\n', cost, results.simulation_time(i));
            
        catch ME
            fprintf('FAILED: %s\n', ME.message);
            results.cost(i) = Inf;
            results.power(i) = 0;
            results.loads(i) = Inf;
            results.simulation_time(i) = toc(iter_start);
        end
        
        % Progress update
        if mod(i, 5) == 0 || i == num_points
            elapsed = toc(start_time);
            remaining = (elapsed / i) * (num_points - i);
            fprintf('    Progress: %d/%d (%.1f%%), Elapsed: %.1f min, Remaining: %.1f min\n', ...
                i, num_points, 100*i/num_points, elapsed/60, remaining/60);
        end
    end
    
    total_time = toc(start_time);
    fprintf('T_buffer optimization Round %d complete (%.1f min)\n', round_num, total_time/60);
    
    % Find and report best result
    [min_cost, best_idx] = min(results.cost);
    best_T_buffer = results.T_buffer(best_idx);
    fprintf('Best T_buffer: %.3f s, Cost: %.4f\n\n', best_T_buffer, min_cost);
    
    % Save intermediate results
    save(fullfile(config.results_dir, sprintf('optimization_round%d.mat', round_num)), 'results');
    
end

function updateWrapperIN(T_buffer, config)
    %% Update T_buffer value in FFP.IN file (not WRAPPER.IN)
    
    % The T_buffer parameter is actually in FFP.IN file
    ffp_file = config.ffp_in;
    
    if ~exist(ffp_file, 'file')
        error('FFP.IN file not found: %s', ffp_file);
    end
    
    % Read file content
    fid = fopen(ffp_file, 'r');
    if fid == -1
        error('Cannot open FFP.IN file for reading');
    end
    
    lines = {};
    while ~feof(fid)
        lines{end+1} = fgetl(fid);
    end
    fclose(fid);
    
    % Update T_buffer line (should be around line 4 in the real FFP.IN)
    for i = 1:length(lines)
        line = lines{i};
        if contains(line, 'T_buffer') && contains(line, '!')
            % Extract comment part
            comment_idx = strfind(line, '!');
            if ~isempty(comment_idx)
                comment = line(comment_idx(1):end);
                lines{i} = sprintf('%.3f   \t%s', T_buffer, comment);
            else
                lines{i} = sprintf('%.3f   \t! T_buffer        		- Buffer time for filtered REWS signal [s]', T_buffer);
            end
            break;
        end
    end
    
    % Write updated file
    fid = fopen(ffp_file, 'w');
    if fid == -1
        error('Cannot open FFP.IN file for writing');
    end
    
    for i = 1:length(lines)
        fprintf(fid, '%s\n', lines{i});
    end
    fclose(fid);
    
end

function [power_metrics, load_metrics] = runOpenFASTOptimization(T_buffer, config)
    %% Run OpenFAST simulations for optimization
    
    % Create temporary directory for this run
    temp_dir = fullfile(config.results_dir, 'temp', sprintf('T_buffer_%.3f', T_buffer));
    if ~exist(temp_dir, 'dir')
        mkdir(temp_dir);
    end
    
    % Initialize metrics
    power_data = [];
    load_data = struct();
    load_data.tower_base = [];
    load_data.blade_root = [];
    
    % Run simulations for each wind speed
    for ws = config.wind_speeds
        
        % Create wind file for this wind speed
        wind_file = createConstantWindFile(ws, config.sim_time, temp_dir);
        
        % Create OpenFAST input file
        openfast_input = createOpenFASTInput(wind_file, config, temp_dir);
        
        % Run OpenFAST simulation
        output_file = runOpenFASTSimulation(openfast_input, config);
        
        if exist(output_file, 'file')
            % Process simulation results
            [power, loads] = processOpenFASTOutput(output_file);
            
            % Accumulate data
            power_data(end+1) = power;
            load_data.tower_base(end+1) = loads.tower_base;
            load_data.blade_root(end+1) = loads.blade_root;
        else
            warning('OpenFAST simulation failed for wind speed %.1f m/s', ws);
            power_data(end+1) = 0;
            load_data.tower_base(end+1) = Inf;
            load_data.blade_root(end+1) = Inf;
        end
    end
    
    % Calculate performance metrics
    power_metrics = struct();
    power_metrics.mean_power = mean(power_data);
    power_metrics.AEP = calculateAEP(power_data, config.wind_speeds);
    
    load_metrics = struct();
    load_metrics.DEL_tower = calculateDEL(load_data.tower_base);
    load_metrics.DEL_blade = calculateDEL(load_data.blade_root);
    load_metrics.DEL_total = load_metrics.DEL_tower + load_metrics.DEL_blade;
    
    % Cleanup temporary files
    if exist(temp_dir, 'dir')
        rmdir(temp_dir, 's');
    end
    
end

function output_file = runOpenFASTSimulation(input_file, config)
    %% Execute OpenFAST simulation
    
    % Prepare command
    openfast_cmd = sprintf('"%s" "%s"', config.openfast_exe, input_file);
    
    % Change to input file directory for relative paths
    [input_dir, ~, ~] = fileparts(input_file);
    current_dir = pwd;
    
    try
        cd(input_dir);
        
        % Run OpenFAST
        [status, cmdout] = system(openfast_cmd);
        
        if status ~= 0
            warning('OpenFAST execution failed:\n%s', cmdout);
            output_file = '';
        else
            % Find output file
            [~, base_name, ~] = fileparts(input_file);
            output_file = fullfile(input_dir, [base_name '.out']);
        end
        
    catch ME
        warning('Error running OpenFAST: %s', ME.message);
        output_file = '';
    end
    
    cd(current_dir);
    
end

function cost = calculateCostFunction(power_metrics, load_metrics, config)
    %% Calculate optimization cost function
    % Minimize loads while maintaining power performance
    
    % Normalize metrics
    ref_power = config.rated_power;
    ref_loads = 1e6;  % Reference load level
    
    % Power component (negative because we want to maximize)
    power_term = -power_metrics.AEP / ref_power;
    
    % Load component (positive because we want to minimize)
    load_term = load_metrics.DEL_total / ref_loads;
    
    % Combined cost function
    cost = config.weight_power * power_term + config.weight_loads * load_term;
    
end

function [power, loads] = processOpenFASTOutput(output_file)
    %% Process OpenFAST output for optimization metrics
    
    try
        % Read OpenFAST output file (.outb or .out)
        if contains(output_file, '.outb')
            data = ReadFASTbinaryIntoStruct(output_file);
        else
            error('Text output files not yet supported. Use .outb files.');
        end
        
        % Extract time series (use last part for steady state)
        time = data.Time;
        steady_start = max(1, find(time >= max(time) - 60, 1)); % Last 60 seconds
        
        % Power calculation
        if isfield(data, 'GenPwr')
            power = mean(data.GenPwr(steady_start:end));
        elseif isfield(data, 'GenPower')
            power = mean(data.GenPower(steady_start:end));
        else
            warning('Power channel not found in output file');
            power = 0;
        end
        
        % Load calculations
        loads = struct();
        
        % Tower base loads
        if isfield(data, 'TwrBsMyt')
            loads.tower_base = std(data.TwrBsMyt(steady_start:end));
        elseif isfield(data, 'TowerBsMyt')
            loads.tower_base = std(data.TowerBsMyt(steady_start:end));
        else
            loads.tower_base = 0;
        end
        
        % Blade root loads
        if isfield(data, 'RootMyb1')
            loads.blade_root = std(data.RootMyb1(steady_start:end));
        elseif isfield(data, 'BladeRootMyb1')
            loads.blade_root = std(data.BladeRootMyb1(steady_start:end));
        else
            loads.blade_root = 0;
        end
        
        % Additional rotor speed for performance assessment
        if isfield(data, 'RotSpeed')
            loads.rotor_speed_std = std(data.RotSpeed(steady_start:end));
        else
            loads.rotor_speed_std = 0;
        end
        
    catch ME
        warning('Error processing OpenFAST output: %s', ME.message);
        power = 0;
        loads = struct('tower_base', Inf, 'blade_root', Inf, 'rotor_speed_std', Inf);
    end
    
end