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
for subject=1:length(d_letter)
    
    subject
    
    % Initialize conf_leak
    conf_leak=0; %parameter theta in the paper
    step = .2;
    direction=1;

    while 1        
        % Simulate n_trials
        signal_letter = d_letter(subject)/2 + randn(n_trials,1);
        signal_color = d_color(subject)/2 + randn(n_trials,1);
        accuracy_letter_fit = signal_letter > 0;
        accuracy_color_fit = signal_color > 0;
        
        % Confidence on letter identity predicts confidence on color task
        conf_letter = give_conf(abs(signal_letter), criteria_letter(subject,:));
        for trial=1:n_trials
            ratio = exp((conf_letter(trial)-mean_conf_letter(subject))*conf_leak);
            conf_color(trial) = give_conf(abs(signal_color(trial)), ...
                criteria_color(subject,:) / ratio);
        end
        
        % Confidence correlation
        corr_conf_fit = r2z(corr(conf_letter, conf_color'));
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