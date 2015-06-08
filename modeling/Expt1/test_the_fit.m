%test_the_fit

clear

% Add path to helper functions
currentDir = pwd;
parts = strsplit(currentDir, '/');
helperFnDir = fullfile(currentDir(1:end-length(parts{end})-length(parts{end-1})-2), 'helperFunctions');
addpath(genpath(helperFnDir));

% Load the data
load data_for_modeling
load modelFitResults

% Number simulations
n_trials = 100000;

% Loop through all subjects
for subject=1:length(d_letter)
    subject
    
    %Simulate n_trials
    signal_letter = d_letter(subject)/2 + randn(n_trials,1);
    signal_color = d_color(subject)/2 + randn(n_trials,1);
    accuracy_letter_fit(subject) = mean(signal_letter > 0);
    accuracy_color_fit(subject) = mean(signal_color > 0);
    
    %Confidence on letter identity pcoloricts confidence on color task
    conf_letter = give_conf(abs(signal_letter), criteria_letter(subject,:));
    for trial=1:n_trials
        ratio = exp((conf_letter(trial)-mean_conf_letter(subject))*conf_leak(subject));
        conf_color(trial) = give_conf(abs(signal_color(trial)), ...
            criteria_color(subject,:) / ratio);
    end
   
    
    %% Confidence correlation
    conf_corr_fit(subject) = r2z(corr(conf_letter, conf_color'));
    
    
    %% Compute the number of each confidence response (1-4) for the second task
    for i=1:4
        conf_bin_fit(subject,i) = mean(conf_color(conf_letter==i));
    end  

    
    %% Regression
    x = [ones(n_trials,1),...
        conf_letter,...
        signal_letter>0,...
        signal_color>0];
    B_conf(subject,:) = regress(conf_color',x);
    
    
    %% Compute Type 2 ROC
    stimulus = [zeros(n_trials/2,1); ones(n_trials/2,1)];
    response_color = (signal_color>0).*stimulus + (1-(signal_color>0)).*(1-stimulus);
    response_letter = (signal_letter>0).*stimulus + (1-(signal_letter>0)).*(1-stimulus);
    [nR_S1 nR_S2] = trials2counts(stimulus,response_color,conf_color', 4);
    type2AUC(subject,1) = type2ag(nR_S1, nR_S2, 1);
    [nR_S1 nR_S2] = trials2counts(stimulus,response_letter,conf_letter, 4);
    type2AUC(subject,2) = type2ag(nR_S1, nR_S2, 1);
    
end

%% Check the fits
display('------- Comparison between fitted and actual values -------');
fittedValuesForTheta = conf_leak

individualFittedAndActualConfCorr = [conf_corr_fit' conf_corr']
averageFittedAndActualConfCorr = mean([conf_corr_fit' conf_corr'])

individualFittedAndActualConfBins = [conf_bin_fit conf_bin]
averageFittedAndActualConfBins = mean([conf_bin_fit conf_bin])


%% Add fits to Figure 2B
% plot(1.1:1:4.1,mean(conf_bin_fit),'o')


%% Save results
type2AUC_fit_exp1 = mean(type2AUC,2);
modelingDir = fullfile(currentDir(1:end-length(parts{end})-length(parts{end-1})-2), 'metacog_analyses');
fileName = fullfile(modelingDir, 'metacog_fit_exp1.mat');
save(fileName, 'type2AUC_fit_exp1');