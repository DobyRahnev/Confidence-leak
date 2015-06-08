%run_ModelFitting

clear

% Add path to helper functions
currentDir = pwd;
parts = strsplit(currentDir, '/');
helperFnDir = fullfile(currentDir(1:end-length(parts{end})-length(parts{end-1})-2), 'helperFunctions');
addpath(genpath(helperFnDir));

% Load the behavioral data with estimated parameters
load data_for_modeling
conf2_orig = conf2; conf4_orig = conf4;

% Number simulations
n_trials = 50000;


% Loop through all subjects
for subject=1:length(d_prime2)
    
    subject
    
    %Initial conf_leak
    conf_leak=0; %parameter theta in the paper
    step = .2;
    direction=1;
    
    while 1       
        % Simulate n_trials
        signal2 = d_prime2(subject)/2 + randn(n_trials,1);
        signal4 = d_prime4(subject)/2 + randn(n_trials,1);
        accuracy2_fit = signal2 > 0;
        accuracy4_fit = signal4 > 0;
        
        conf2(1) = give_conf(abs(signal2(1)), criterion2(subject)) - 1; %conf is 0 or 1
        conf4(1) = give_conf(abs(signal4(1)), criterion4(subject)) - 1; %conf is 0 or 1
        for trial=2:n_trials
            ratio = exp((conf2(trial-1)-conf2_orig(subject))*conf_leak);
            conf2(trial) = give_conf(abs(signal2(trial)), ...
                criterion2(subject) / ratio) - 1; %conf is 0 or 1
            ratio = exp((conf4(trial-1)-conf4_orig(subject))*conf_leak);
            conf4(trial) = give_conf(abs(signal4(trial)), ...
                criterion4(subject) / ratio) - 1; %conf is 0 or 1
        end
        
        % Confidence correlation
        all_conf = [conf2'; conf4'];
        conf_corr_fit = r2z(corr(all_conf(1:end-1), all_conf(2:end)));
        
        if conf_corr_fit < conf_corr(subject) - .001
            if direction==1
                conf_leak = conf_leak + step;
            else
                direction=1;
                step = step/2;
                conf_leak = conf_leak + step;
            end
        elseif conf_corr_fit > conf_corr(subject) + .001
            if direction==-1
                conf_leak = conf_leak - step;
            else
                direction=-1;
                step = step/2;
                conf_leak = conf_leak - step;
            end
        else
            conf_leak_final(subject) = conf_leak;
            break
        end
    end
end

% Save the fitted results
conf_leak = conf_leak_final;
save modelFitResults conf_leak