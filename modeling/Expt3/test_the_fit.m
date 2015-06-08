%test_the_fit

clear

% Add path to helper functions
currentDir = pwd;
parts = strsplit(currentDir, '/');
helperFnDir = fullfile(currentDir(1:end-length(parts{end})-length(parts{end-1})-2), 'helperFunctions');
addpath(genpath(helperFnDir));

% Load the data
load data_for_modeling
conf2_orig = conf2; conf4_orig = conf4;
load modelFitResults

% Number simulations
n_trials = 50000;

% Loop through all subjects
for subject=1:length(d_prime2)
    
    subject
        
    % Simulate n_trials
    signal2 = d_prime2(subject)/2 + randn(n_trials,1);
    signal4 = d_prime4(subject)/2 + randn(n_trials,1);
    accuracy2_fit = signal2 > 0;
    accuracy4_fit = signal4 > 0;
    
    conf2(1) = give_conf(abs(signal2(1)), criterion2(subject)) - 1; %conf is 0 or 1
    conf4(1) = give_conf(abs(signal4(1)), criterion4(subject)) - 1; %conf is 0 or 1
    for trial=2:n_trials
        ratio = exp((conf2(trial-1)-conf2_orig(subject))*conf_leak(subject));
        conf2(trial) = give_conf(abs(signal2(trial)), ...
            criterion2(subject) / ratio) - 1; %conf is 0 or 1
        ratio = exp((conf4(trial-1)-conf4_orig(subject))*conf_leak(subject));
        conf4(trial) = give_conf(abs(signal4(trial)), ...
            criterion4(subject) / ratio) - 1; %conf is 0 or 1
    end
    
    % Confidence correlation
    all_conf = [conf2'; conf4'];
    conf_corr_fit(subject) = r2z(corr(all_conf(1:end-1), all_conf(2:end)));
    
    % Mean conf
    conf2_mean_fit(subject) = mean(conf2);
    conf4_mean_fit(subject) = mean(conf4);
    
    % Regression
    all_signal = [signal2;signal4];
    x = [ones(2*n_trials-1,1),...
        all_conf(1:end-1),...
        all_signal(1:end-1)>0,...
        all_signal(2:end)>0];
    B_conf(subject,:) = regress(all_conf(2:end),x);
    
    x = [ones(n_trials-1,1),...
        conf2(1:end-1)',...
        signal2(1:end-1)>0,...
        signal2(2:end)>0];
    B_conf2(subject,:) = regress(conf2(2:end)',x);
    
    x = [ones(n_trials-1,1),...
        conf4(1:end-1)',...
        signal4(1:end-1)>0,...
        signal4(2:end)>0];
    B_conf4(subject,:) = regress(conf4(2:end)',x);
    
    
    % Compute Type 2 AUC
    stimulus = rem(randperm(2*n_trials),2)';
    response = (all_signal>0).*stimulus + (1-(all_signal>0)).*(1-stimulus);
    [nR_S1 nR_S2] = trials2counts(stimulus,response,all_conf+1, 2);
    type2AUC(subject) = type2ag(nR_S1, nR_S2, 1);
end

%% Check the fits
display('------- Comparison between fitted and actual values -------');
fittedValuesForTheta = conf_leak

individualFittedAndActualConfCorr = [conf_corr_fit' conf_corr']
averageFittedAndActualConfCorr = mean([conf_corr_fit' conf_corr'])

individualFittedAndActualConf2targets = [conf2_mean_fit' conf2_orig']
averageFittedAndActualConf2targets = mean([conf2_mean_fit' conf2_orig'])

individualFittedAndActualConf4targets = [conf4_mean_fit' conf4_orig']
averageFittedAndActualConf4targets = mean([conf4_mean_fit' conf4_orig'])


%% Add fits to Figure 5D
%plot([1.1,2.1],[mean(B_conf2(:,2)),mean(B_conf4(:,2))],'o')


%% Save results
type2AUC_fit_exp3 = type2AUC';
modelingDir = fullfile(currentDir(1:end-length(parts{end})-length(parts{end-1})-2), 'metacog_analyses');
fileName = fullfile(modelingDir, 'metacog_fit_exp3.mat');
save(fileName, 'type2AUC_fit_exp3');