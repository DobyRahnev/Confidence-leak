%run_ModelFitting

clear

% Add path to helper functions
currentDir = pwd;
parts = strsplit(currentDir, '/');
helperFnDir = fullfile(currentDir(1:end-length(parts{end})-length(parts{end-1})-2), 'helperFunctions');
addpath(genpath(helperFnDir));

% Load the behavioral data with estimated parameters
load data_for_modeling

% Number simulations
n_trials = 100000;


% Loop through all subjects
for subject=1:length(d_VAS)
    
    subject
    
    % Initialize conf_leak
    conf_leak=0; %parameter theta in the paper
    step = .2;
    direction=1;
    
    while 1       
        % Simulate n_trials
        signal_optOut = d_optOut/2 + randn(n_trials,1);
        signal_VAS = d_VAS(subject)/2 + randn(n_trials,1);
        accuracy_optOut_fit = signal_optOut > 0;
        accuracy_VAS_fit = signal_VAS > 0;
        conf_VAS = give_conf(abs(signal_VAS), criteria_VAS(subject,:))-1;
        for trial=1:n_trials
            ratio = exp((conf_VAS(trial)-conf_VAS_mean(subject))*conf_leak);
            conf_optOut(trial) = give_conf(abs(signal_optOut(trial)), ...
                criteria_optOut(subject) / ratio);
        end
        
        % Confidence correlation
        corr_conf_fit = r2z(corr(conf_optOut', conf_VAS));
        if corr_conf_fit < conf_corr(subject) - .001;
            if direction==1
                conf_leak = conf_leak + step;
            else
                direction=1;
                step = step/2;
                conf_leak = conf_leak + step;
            end
        elseif corr_conf_fit > conf_corr(subject) + .001
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