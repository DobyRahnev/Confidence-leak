%analyzeResults_expt2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Analysis of Experiment 2
%
% The experiment included 2 tasks: X/O and red/blue, as well as two ways of
% asking for confidence: VAS vs. opt out.  
%
% This code recreates all the analyses from our manuscript.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
close all

% Bad subjects: subjects that opted out extreme amounts:
%S10: 400/400
%S9: 396/400
%S8: 1/400
%S5: 5/400
selected_subjects = [1:4,6,7,11:22];
number_subjects = length(selected_subjects);

% Add path to helper functions
currentDir = pwd;
parts = strsplit(currentDir, '/');
helperFnDir = fullfile(currentDir(1:end-length(parts{end})), 'helperFunctions');
addpath(genpath(helperFnDir));

% Parameters for PDF analysis
integration_window = .15;
N=1000;
y_bins_all{1} = zeros(N+1,1);
y_bins_all{2} = zeros(N+1,1);


%% Loop through all subjects
for subject_number=1:number_subjects
    
    %% Load the data
    file_name = ['Data/results_s' num2str(selected_subjects(subject_number)) ''];
    eval(['load ' file_name '']);
    number_blocks = size(p.rt,1);
    number_trials_per_block = size(p.rt,2);
    
    
    %% Figure out task ordering and compute basic vectors
    VAS = (1-p.task1_is_scale)*3+1; %1: first task is VAS; 4: second task is VAS
    opt_out = 5 - VAS; %1: first task is opt out; 4: second task is opt out
    color = (1-p.task1_is_color)*3+1; %1: first task is color; 4: second task is color
    letter = 5 - color; %1: first task is letter identity; 4: second task is letter identity
    
    % Compute stimulus for VAS
    if p.task1_is_scale == p.task1_is_color %VAS is color
        stimulus_VAS = 1 - [p.red{1}, p.red{2}, p.red{3}, p.red{4}]'; %0:red, 1:blue
    else
        stimulus_VAS = 1 - [p.x_es{1}, p.x_es{2}, p.x_es{3}, p.x_es{4}]'; %0:X, 1:O
    end
    
    % Determine the response and confidence on VAS and opt out
    acc_VAS = reshape(p.answers(:,:,VAS+2)',400,1);
    acc_optOut = reshape(p.answers(:,:,opt_out+2)',400,1);
    if p.task1_is_scale
        rt_VAS = reshape(p.rt(:,:,1)',400,1) - 1;
        rt_optOut = reshape(p.rt(:,:,2)',400,1) - reshape(p.rt(:,:,3)',400,1);
    else
        rt_optOut = reshape(p.rt(:,:,1)',400,1) - 1;
        rt_VAS = reshape(p.rt(:,:,2)',400,1) - reshape(p.rt(:,:,1)',400,1);
    end
    conf_VAS = reshape(p.answers(:,:,VAS+1)',400,1);
    conf_optOut = reshape(p.answers(:,:,opt_out+1)',400,1);
    response_VAS = reshape(p.answers(:,:,VAS)',400,1) - 1;
    response_optOut = reshape(p.answers(:,:,opt_out)',400,1) - 1;
    
    % Determine the response and confidence on color and letter identity
    acc_color = reshape(p.answers(:,:,color+2)',400,1);
    acc_letter = reshape(p.answers(:,:,letter+2)',400,1);
    conf_color = reshape(p.answers(:,:,color+1)',400,1);
    conf_letter = reshape(p.answers(:,:,letter+1)',400,1);
    response_color = reshape(p.answers(:,:,color)',400,1) - 1; %0:red, 1:blue
    response_letter = reshape(p.answers(:,:,letter)',400,1) - 1; %0:X, 1:O 
    
    
    %% Compute basic values
    conf_optOut_mean(subject_number) = mean(conf_optOut)-1;
    conf_VAS_mean(subject_number) = 100*mean(conf_VAS);
    acc_twoTasks(subject_number,:) = [mean(acc_VAS), mean(acc_optOut(acc_optOut<9))];
    total_points(subject_number) = p.total_points;
    for i=1:2
        conf_VAS_depending_on_optOut(subject_number,i) = mean(conf_VAS(conf_optOut==i));
    end
    [d_VAS(subject_number), criteria_VAS(subject_number,:)] = estimate_100_std_criteria(stimulus_VAS, response_VAS, round(100*conf_VAS));
    
    
    %% Confidence leak: simple correlation
    [r_ind_conf p_ind_conf(subject_number)] = corr(conf_VAS, conf_optOut);
    conf_corr_raw(subject_number) = r_ind_conf;
    conf_corr(subject_number) = r2z(r_ind_conf);
    
    % Compute accuracy correlation for trials with high confidence on both tasks
    if median(conf_VAS) == 1
        median_conf_VAS = .999; %correction for subjects that had median confidence of 1
    else
        median_conf_VAS = median(conf_VAS);
    end
    accu_corr_highConfOnBoth(subject_number) = r2z(corr(acc_VAS(acc_optOut<9&conf_VAS>median_conf_VAS), acc_optOut(acc_optOut<9&conf_VAS>median_conf_VAS)));
    accu_corr_highConfOnOptOut(subject_number) = r2z(corr(acc_VAS(acc_optOut<9), acc_optOut(acc_optOut<9)));
    for i=1:2
        d_bin(subject_number,i) = compute_dprime(stimulus_VAS(acc_optOut==2-i), response_VAS(acc_optOut==2-i));
        trial_num(subject_number,i) = sum(acc_optOut==2-i);
    end
    
    
    %% Confidence leak: regression analysis
    if p.task1_is_color == p.task1_is_scale
        diff_VAS = reshape(p.color_diff',400,1); %1: difficult, 2: easy
        diff_optOut = reshape(p.xo_diff',400,1); %1: difficult, 2: easy
    else
        diff_VAS = reshape(p.xo_diff',400,1); %1: difficult, 2: easy
        diff_optOut = reshape(p.color_diff',400,1); %1: difficult, 2: easy
    end
    x = [ones(400,1),...
        conf_VAS, ... %confidence on VAS task
        acc_VAS, ... %accuracy on VAS task
        acc_optOut,... %accuracy on opt out task
        rt_VAS,... %RT on VAS task
        rt_optOut,... %RT on opt out task
        diff_VAS,... %difficulty on VAS task
        diff_optOut]; %difficulty on opt out task
    [B_conf(subject_number,:),BINT] = regress(conf_optOut-1, x); %B_conf(2) is the critical
    
    
    %% Compute metacognition    
    conf_VAS_transformed = 4*ones(400,1);
    for i=3:-1:1
        conf_VAS_transformed(conf_VAS<prctile(conf_VAS,25*i)) = i;
    end
    [nR_S1 nR_S2] = trials2counts(stimulus_VAS,response_VAS,conf_VAS_transformed, 4);
    type2AUC(subject_number,1) = type2ag(nR_S1, nR_S2, 1);
    
    
    %% Plot density of VAS as a function of opt out
    x = (0:1/N:1)';
    y_bins{1} = x.*0;
    y_bins{2} = x.*0;
    for j=1:2
        vector = conf_VAS(conf_optOut==j);
        for i = 1:length(vector)
            bot = round((vector(i)-integration_window)*N)./N;
            top = round((vector(i)+integration_window)*N)./N;
            if top > 1
                top = 1;
            end
            q1 = find(x==bot,1);
            q2 = find(x==top,1);
            y_bins{j}(q1:q2) = y_bins{j}(q1:q2) + 1/length(vector);
        end
        y_bins_all{j} = y_bins_all{j} + y_bins{j};
    end
    
end

%% Confidence leak: Correlation analysis
display('------- Correlation analyses -------');
individualConfCorrelationValues = conf_corr
numSignificantIndividuals = sum(p_ind_conf<.05)
mean_conf_corr = mean(conf_corr)
ci_conf_corr = [mean_conf_corr - 1.96*std(conf_corr)/sqrt(number_subjects), mean_conf_corr + 1.96*std(conf_corr)/sqrt(number_subjects)]
oneSample_tTest(conf_corr, 'Conf leak (correlation) > 0');
effect_size = mean_conf_corr / std(conf_corr)

% Compute Bayes factor
distribParams.mean = 0;
distribParams.SD = 1;
distribParams.tail = 1;
BayesFactor = bayes_factor(conf_corr, 0, distribParams)


%% Confidence leak: Regression analysis
display('------- Regression analyses -------');
individualRegressionBetas = B_conf(:,2)'
mean_beta = mean(B_conf(:,2))
ci_beta = [mean_beta - 1.96*std(B_conf(:,2))/sqrt(number_subjects), mean_beta + 1.96*std(B_conf(:,2))/sqrt(number_subjects)]
oneSample_tTest(B_conf(:,2), 'Conf leak (regression) > 0');

% Control analyses for accuracy and RT
[H P] = ttest(B_conf);
pValuesForAllRegressors = P %P(3) and P(5) test for the ability of accuracy and RT on VAS task to predict confidence on opt out task


%% Accuracy leak?
display('------- Accuracy leak? -------');
accuracyCorrelation = mean(accu_corr_highConfOnOptOut)
oneSample_tTest(accu_corr_highConfOnOptOut, 'Accuracy leak > 0');
effect_size = mean(accu_corr_highConfOnOptOut / std(accu_corr_highConfOnOptOut))

% Stats on relationship between accuracy and confidence leak
display('------- Correlation between accuracy leak and confidence leak -------');
[r p] = corr(conf_corr', accu_corr_highConfOnOptOut')


%% Plot individual fits of confidence correlation
figure
conf_VAS_depending_on_optOut = conf_VAS_depending_on_optOut *100;
ax = axes;
plot([1 2], [conf_VAS_depending_on_optOut(1,1), conf_VAS_depending_on_optOut(1,2)], 'k-', 'LineWidth', 2);
hold
for i=2:number_subjects
    plot([1 2], [conf_VAS_depending_on_optOut(i,1), conf_VAS_depending_on_optOut(i,2)], 'k-', 'LineWidth', 2);
end
xlabel('Confidence on opt-out task', 'FontSize',30)
ylabel('Confidence on VAS', 'FontSize',30);
xlim([1, 2]);
ylim([0 100]);
set(ax,'XTick',1:2);
set(ax,'YTick',0:20:100);
axis('square')


%% Plot VAS bins as a function of opt out
smooth = 50; %The actual moving average is 2*100*smooth/N, which is 10 for smooth=50 and N=1000
for i=1:2
    for j=1:length(y_bins_all{i})
        begin = j - smooth; if begin < 1; begin = 1; end
        ending = j + smooth; if ending > N; ending = N; end
        y_bins_all_new{i}(j) = mean(y_bins_all{i}(begin:ending));
    end
end
figure
plot(100*x,y_bins_all_new{1}/number_subjects, 'r', 'LineWidth', 4)
hold
plot(100*x,y_bins_all_new{2}/number_subjects, 'b', 'LineWidth', 4)
legend('Low confidence (opted out)', 'High confidence (did not opt out)');
xlabel('Confidence on VAS');
ylabel('Probability density');


%% Save data for modeling and metacognition analyses
% Save results for modeling
d_optOut = mean(d_VAS);
for subject=1:number_subjects
    criteria_optOut(subject) = std_criteria_from_dprime(d_optOut, conf_optOut_mean(subject), 2);
end
modelingDir = fullfile(currentDir(1:end-length(parts{end})), 'modeling', 'Expt2');
fileName = fullfile(modelingDir, 'data_for_modeling.mat');
save(fileName, 'd_VAS','d_optOut','criteria_VAS','criteria_optOut','conf_VAS_mean','conf_optOut_mean','conf_corr');

% Save data for matecognition analyses
type2AUC_exp2 = type2AUC; conf_corr_exp2 = conf_corr';
metacogDir = fullfile(currentDir(1:end-length(parts{end})), 'metacog_analyses');
fileName = fullfile(metacogDir, 'metacog_exp2.mat');
save(fileName, 'type2AUC_exp2','conf_corr_exp2');