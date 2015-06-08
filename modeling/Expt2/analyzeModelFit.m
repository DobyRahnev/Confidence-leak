%analyzeModelFit

clear

% Add path to helper functions
currentDir = pwd;
parts = strsplit(currentDir, '/');
helperFnDir = fullfile(currentDir(1:end-length(parts{end})-length(parts{end-1})-2), 'helperFunctions');
addpath(genpath(helperFnDir));

% Load the fitted data
load modelFitResults
number_subjects = length(conf_leak);

% Confidence leak: correlation analysis
display('------- Correlation analyses -------');
individualConfCorrelationValues = conf_leak

display('------- Outlier removal -------');
SD_conf_leak = std(conf_leak)
outlier_SD = (conf_leak(7)-mean(conf_leak))/std(conf_leak)
conf_leak = conf_leak([1:6,8:end]);

display('------- Results with outlier removed analyses -------');
mean_conf_corr = mean(conf_leak)
ci_conf_corr = [mean_conf_corr - 1.96*std(conf_leak)/sqrt(number_subjects), mean_conf_corr + 1.96*std(conf_leak)/sqrt(number_subjects)]
oneSample_tTest(conf_leak, 'Conf leak (correlation) > 0');
effect_size = mean_conf_corr / std(conf_leak)