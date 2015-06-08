%analyzeResults_expt4

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Analysis of Experiment 4
%
% This code recreates all the analyses from our manuscript.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
close all

% Load data
load resultsAllSubj_confidence
number_subjects = size(confAllSubj,1);

% Add path to helper functions
currentDir = pwd;
parts = strsplit(currentDir, '/');
helperFnDir = fullfile(currentDir(1:end-length(parts{end})), 'helperFunctions');
addpath(genpath(helperFnDir));


%% Loop through all subjects
for sub=1:number_subjects
    conf = {};
    
    % Loop through the 5 blocks
    for block=1:5
        conf_block = squeeze(confAllSubj(sub,block,:))';
        
        % On some trials, subjects didn't provide a confidence rating; here
        % we exclude these trials, and remove them from the autocorrelation
        noConfTrials = find(conf_block<1);
        if isempty(noConfTrials)
            conf{end+1} = conf_block;
        else
            noConfTrials(end+1:end+2) = [0 length(conf_block)+1];
            noConfTrials = sort(noConfTrials);
            for i=1:length(noConfTrials)-1
                if noConfTrials(i+1) - noConfTrials(i) >= 3
                    conf{end+1} = conf_block(noConfTrials(i)+1:noConfTrials(i+1)-1);
                end
            end
        end
    end
    
    % Compute the confidence autocorelation
    conf_corr(sub) = autocorrelation(conf);
        
end

%% Confidence leak: Correlation analysis
display('------- Correlation analyses -------');
individualConfCorrelationValues = conf_corr
mean_conf_corr = mean(conf_corr)
ci_conf_corr = [mean_conf_corr - 1.96*std(conf_corr)/sqrt(number_subjects), mean_conf_corr + 1.96*std(conf_corr)/sqrt(number_subjects)]
oneSample_tTest(conf_corr, 'Conf leak (correlation) > 0');
effect_size = mean_conf_corr / std(conf_corr)

% Compute Bayes factor
distribParams.mean = 0;
distribParams.SD = 1;
distribParams.tail = 1;
BayesFactor = bayes_factor(conf_corr, 0, distribParams)


%% Compute correlation with the metacognitive scores (M) reported in McCurdy et al. (2013)
display('------- Correlation between confidence leak and metacognition -------');
load metacogScores_McCurdy2013
[r_ConfLeak_Metacog p_ConfLeak_Metacog] = corr(M, conf_corr')