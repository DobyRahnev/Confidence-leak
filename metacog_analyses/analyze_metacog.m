%analyze_metacog

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Analysis of the relationship between type 2 AUC and confidence leak.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear

%% Load the results files from Experiments 1-3
load metacog_exp1
load metacog_exp2
load metacog_exp3


%% Alternatively, check the model fits instead of the actual data
% load metacog_fit_exp1
% load metacog_fit_exp2
% load metacog_fit_exp3
% type2AUC_exp1 = type2AUC_fit_exp1;
% type2AUC_exp2 = type2AUC_fit_exp2;
% type2AUC_exp3 = type2AUC_fit_exp3;


%% Compute the correlation between confidence leak and type 2 AUC for each experiment
conf_corr = [conf_corr_exp1; conf_corr_exp2; conf_corr_exp3];
type2AUC = [type2AUC_exp1; type2AUC_exp2; type2AUC_exp3];
[r_ind_exp(1) p(1)] = corr(conf_corr_exp1, type2AUC_exp1);
[r_ind_exp(2) p(2)] = corr(conf_corr_exp2, type2AUC_exp2);
[r_ind_exp(3) p(3)] = corr(conf_corr_exp3, type2AUC_exp3);
r_ind_exp
p


%% Compute the correlation between confidence leak and type 2 AUC for combined data
[r p] = corr(conf_corr, type2AUC)
number_subjects = length(type2AUC);
CI = z2r([r2z(r) - 1.96/sqrt(number_subjects-3), r2z(r) + 1.96/sqrt(number_subjects-3)])
[r,t,p]=spear(conf_corr, type2AUC)

%Compute the correlation without the outliers
cutoff = .5;
[r p] = corr(conf_corr(type2AUC>cutoff&conf_corr<1), type2AUC(type2AUC>cutoff&conf_corr<1))
number_subjects = sum((type2AUC>cutoff&conf_corr<1));
CI = z2r([r2z(r) - 1.96/sqrt(number_subjects-3), r2z(r) + 1.96/sqrt(number_subjects-3)])


%% Figure 6
plot_correlation(conf_corr(type2AUC>cutoff&conf_corr<1), type2AUC(type2AUC>cutoff&conf_corr<1), [-.05 .6], [.5 .9])