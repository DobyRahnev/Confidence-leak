%analyzeResults_expt1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Analysis of Experiment 1
%
% The experiment included 2 tasks: X/O (first) and red/blue (second). The
% X/O task always had the same difficulty, while red/blue task changed in
% difficulty between the 4 runs.
%
% This code recreates all the analyses from our manuscript.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
close all

% Select subjects (S9 is completely at chance)
selected_subjects = [1:8,10:27];
number_subjects = length(selected_subjects);

% Initialize some parameters
prev_conf1 = []; prev_conf4=[];
subj_for_other14_analysis=[];

% Add path to helper functions
currentDir = pwd;
parts = strsplit(currentDir, '/');
helperFnDir = fullfile(currentDir(1:end-length(parts{end})), 'helperFunctions');
addpath(genpath(helperFnDir));


%% Loop through all subjects
for subject_number=1:number_subjects
    
    %Load the data
    file_name = ['Data/results_s' num2str(selected_subjects(subject_number)) ''];
    eval(['load ' file_name '']);
    
    %Size of blocks and runs
    number_blocks = size(p.rt,1);
    number_trials_per_block = size(p.rt,2);
    
    
    %% Set the order of the easy and difficult runs
    if p.red_run(1) == 23
        hard = [1,3];
        easy = [2,4];
        difficulty = [2*ones(100,1);ones(100,1);2*ones(100,1);ones(100,1)];
    else
        hard = [2,4];
        easy= [1,3];
        difficulty = [ones(100,1);2*ones(100,1);ones(100,1);2*ones(100,1)];
    end
    
    
    %% Compute mean accuracy and confidence for each task
    accuracy_letter(subject_number) = mean(mean(p.answers(:,:,3),2));
    accuracy_color(subject_number) = mean(mean(p.answers(:,:,6),2));
    confidence_letter(subject_number) = mean(mean(p.answers(:,:,2),2));
    confidence_color(subject_number) = mean(mean(p.answers(:,:,5),2));
    
    accuracy_color_difficulty(subject_number,1) = mean(mean(p.answers(hard,:,6),2));
    accuracy_color_difficulty(subject_number,2) = mean(mean(p.answers(easy,:,6),2));
    confidence_color_difficulty(subject_number,1) = mean(mean(p.answers(hard,:,5),2));
    confidence_color_difficulty(subject_number,2) = mean(mean(p.answers(easy,:,5),2));
    
    
    %% Determine the vectors for stimulus, response, and confidence for each task
    stimulus{1} = 1 - [p.x_es{1}, p.x_es{2}, p.x_es{3}, p.x_es{4}]'; %0:X, 1:O
    stimulus{2} = 1 - [p.red{1}, p.red{2}, p.red{3}, p.red{4}]'; %0:red, 1:blue
    response{1} = reshape(p.answers(:,:,1)',400,1) - 1; %0:X, 1:O
    response{2} = reshape(p.answers(:,:,4)',400,1) - 1; %0:red, 1:blue
    accuracy{1} = reshape(p.answers(:,:,3)',400,1); %letter identity task
    accuracy{2} = reshape(p.answers(:,:,6)',400,1); %color task
    rt{1} = reshape(p.rt(:,:,1)',400,1) - 1; %letter identity task
    rt{2} = reshape(p.rt(:,:,3)',400,1) - reshape(p.rt(:,:,2)',400,1) - .3; %color task
    confidence{1} = reshape(p.answers(:,:,2)',400,1); %letter identity task
    confidence{2} = reshape(p.answers(:,:,5)',400,1); %color task
    mean_rt(subject_number, :) = mean(mean(p.rt,2));
    
    
    %% Confidence leak: simple correlation
    [corr_conf_raw(subject_number) p_conf_corr(subject_number)] = corr(confidence{1}, confidence{2});
    conf_corr(subject_number) = r2z(corr(confidence{1}, confidence{2}));
    corr_accuracy(subject_number) = r2z(corr(accuracy{1}, accuracy{2}));
    
    
    %% Confidence leak: regression analysis
    x = [ones(400,1),...
        confidence{1},...
        accuracy{1},...
        accuracy{2},...
        rt{1},...
        rt{2},...
        difficulty];
    regressCoef(subject_number,:) = regress(confidence{2},x);
    
    % Regression analysis for Figure 2A
    x = [ones(400,1),...
        confidence{1}];
    regressCoef_forPlot(subject_number,:) = regress(confidence{2},x);
    
    % Analysis for Figure 2B
    for i=1:4
        conf_bin(subject_number,i) = mean(confidence{2}(confidence{1}==i));
    end
    
    
    %% Accuracy leak?
    for i=1:2
        d_bin(subject_number,i) = std_criteria(stimulus{2}(accuracy{1}==2-i), response{2}(accuracy{1}==2-i), confidence{2}(accuracy{1}==2-i), 4);
    end
    
    
    %% Correlations over different timescales (Nikolic et al)
    scales = [5, 10, 20, 50, 100, 200, 400];
    num_scales = length(scales);
    for i=1:length(scales)
        scaled_r(subject_number,i) = r2z(scaled_correlation(confidence{1}, confidence{2}, scales(i)));
    end
    
    
    %% Causal test: accuracy and confidence on letter identity task by manipulating the difficulty on color task
    for difficultyLevel=1:2
        accuracy_easyDiff(subject_number,difficultyLevel) = mean(accuracy{1}(difficulty==difficultyLevel));
        confidence_easyDiff(subject_number,difficultyLevel) = mean(confidence{1}(difficulty==difficultyLevel));
    end
    
    %% Confidence on one task for confidence of 1 or 4 on the other
    for block = 1:number_blocks
        other1 = zeros(3,1); other4 = zeros(3,1);
        for j=1:number_trials_per_block
            if (p.answers(block,j,2) == 1 && p.answers(block,j,5) ~= 1) || (p.answers(block,j,2) ~= 1 && p.answers(block,j,5) == 1)
                conf_other = p.answers(block,j,2) + p.answers(block,j,5) - 2;
                other1(conf_other) = other1(conf_other) + 1;
            end
            if (p.answers(block,j,2) == 4 && p.answers(block,j,5) ~= 4) || (p.answers(block,j,2) ~= 4 && p.answers(block,j,5) == 4)
                conf_other = p.answers(block,j,2) + p.answers(block,j,5) - 4;
                other4(conf_other) = other4(conf_other) + 1;
            end
        end
    end
    other1_save(subject_number,:) = other1;
    other4_save(subject_number,:) = other4;
    cutoff_total_trials = 5;
    if sum(other1) >= cutoff_total_trials && sum(other4) >= cutoff_total_trials
        prev_conf1(size(prev_conf1,1)+1,:) = other1/sum(other1);
        prev_conf4(size(prev_conf4,1)+1,:) = other4/sum(other4);
        subj_for_other14_analysis(end+1) = subject_number;
    end
    
    
    %% Compute Type 2 AUC
    [nR_S1 nR_S2] = trials2counts(stimulus{1},response{1},confidence{1}, 4);
    type2AUC(subject_number,1) = type2ag(nR_S1, nR_S2, 1);
    [nR_S1 nR_S2] = trials2counts(stimulus{2},response{2},confidence{2}, 4);
    type2AUC(subject_number,2) = type2ag(nR_S1, nR_S2, 1);
    
    
    %% Compute d' and criteria (for modeling)
    [d_letter(subject_number), criteria_letter(subject_number,:)] = std_criteria(stimulus{1}, response{1}, confidence{1}, 4);
    [d_color(subject_number), criteria_color(subject_number,:)] = std_criteria(stimulus{2}, response{2}, confidence{2}, 4);
    mean_conf_letter(subject_number) = mean(confidence{1});
    mean_conf_color(subject_number) = mean(confidence{2});
    
    
end

%% Basic results: percent correct and confidence
display('------- Basic results: average % correct and confidence -------');
mean_accuracy_letterTask = mean(accuracy_letter)
mean_accuracy_colorTask = mean(accuracy_color)
mean_conf_letterTask = mean(confidence_letter)
mean_conf_colorTask = mean(confidence_color)

mean_accuracy_colorTask_difficulty = mean(accuracy_color_difficulty)
mean_conf_colorTask_difficulty = mean(confidence_color_difficulty)


%% Confidence leak: Correlation analysis
display('------- Correlation analyses -------');
individualConfCorrelationValues = conf_corr
numSignificantIndividuals = sum(p_conf_corr<.05)
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
individualRegressionBetas = regressCoef(:,2)'
mean_beta = mean(regressCoef(:,2))
ci_beta = [mean_beta - 1.96*std(regressCoef(:,2))/sqrt(number_subjects), mean_beta + 1.96*std(regressCoef(:,2))/sqrt(number_subjects)]
oneSample_tTest(regressCoef(:,2), 'Conf leak (regression) > 0');

% Repeated measures ANOVA
confidence_bin = reshape(repmat(1:4,number_subjects,1),4*number_subjects,1);
subject = repmat([1:number_subjects]',4,1);
x = {confidence_bin,subject};
anovan(reshape(conf_bin,4*number_subjects,1),x,'model','full','random',2,...
    'varnames',{'Confidence bin';'Subject'}); % look only at the main effect of "Confidence bin"

% Control analyses for accuracy and RT
[H P] = ttest(regressCoef);
pValuesForAllRegressors = P %P(3) and P(5) test for the ability of accuracy and RT on color identity task to predict confidence on the color task


%% Accuracy leak?
display('------- Accuracy leak? -------');
% Stats on accuracy leak
mean_dPrime = mean(d_bin)
oneSample_tTest(d_bin(:,1) - d_bin(:,2), 'Accuracy leak > 0');
effect_size = mean(d_bin(:,1) - d_bin(:,2)) / mean(std(d_bin))

% Stats on relationship between accuracy and confidence leak
display('------- Correlation between accuracy leak and confidence leak -------');
[r p] = corr(conf_corr', d_bin(:,1)-d_bin(:,2))


%% Confidence correlation as a function of window length (scaled correlation, Nikolic et al)
% Repeated measures ANOVA on the differences between the correlations
corr_window = reshape(repmat(1:num_scales,number_subjects,1),num_scales*number_subjects,1);
subject = repmat([1:number_subjects]',num_scales,1);
x = {corr_window,subject};
anovan(reshape(scaled_r,num_scales*number_subjects,1),x,'model','full','random',2,...
    'varnames',{'Correlation window';'Subject'}); % look only at the main effect of "Correlation window"


%% Causal test: accuracy and confidence on letter identity task by manipulating the difficulty on color task
display('------- Results of the causal test of confidence leak -------');
oneSample_tTest(confidence_easyDiff(:,1) - confidence_easyDiff(:,2), 'confidence on easy trials > confidence on difficult trials');
oneSample_tTest(accuracy_easyDiff(:,1) - accuracy_easyDiff(:,2), 'accuracy on easy trials > accuracy on difficult trials');


%% Response priming control: Response pattern for '1' and '4' responses without repetitions
display('------- Response priming analysis -------');
confidence1_pairedWith234 = mean(prev_conf1)
confidence4_pairedWith123 = mean(prev_conf4)

% Do repeated measures ANOVA
conf1 = reshape(repmat([1:3,1:3],length(prev_conf1),1),6*length(prev_conf1),1);
conf4 = [ones(3*length(prev_conf1),1); 2*ones(3*length(prev_conf1),1)];
subject = repmat([1:length(prev_conf1)]',6,1);
x = {conf1,conf4,subject};
y = [reshape(prev_conf1,3*length(prev_conf1),1); reshape(prev_conf4,3*length(prev_conf1),1)];
anovan(y,x,'model','full','random',3,...
    'varnames',{'Conf1';'Conf4';'Subject'}); %look at interaction between Conf1 and Conf4

%Plot the results of this analysis
plot_14ResponsePattern(prev_conf1, prev_conf4)


%% Figure 2A: Plot individual fits of confidence correlation
figure
ax = axes;
plot([0 5], [regressCoef_forPlot(1,1), regressCoef_forPlot(1,1) + 5*regressCoef_forPlot(1,2)], 'k-', 'LineWidth', 2);
hold
for i=2:number_subjects
    plot([0 5], [regressCoef_forPlot(i,1), regressCoef_forPlot(i,1) + 5*regressCoef_forPlot(i,2)], 'k-', 'LineWidth', 2);
end
xlabel('Confidence on letter identity task', 'FontSize',30)
ylabel('Confidence on color task', 'FontSize',30);
xlim([1, 4]);
ylim([1, 4]);
set(ax,'XTick',1:4);
set(ax,'YTick',1:4);
axis('square')


%% Plot Figure 2B and 2C
plot_consecutive_bars(conf_bin, 'Confidence on letter identity task', 'Confidence on color task', 0);
plot_consecutive_bars(d_bin, 'Accuracy on letter identity task', 'Performance (d'') on color task', 0);


%% Save data for modeling and metacognition analyses
% Save results for modeling
modelingDir = fullfile(currentDir(1:end-length(parts{end})), 'modeling', 'Expt1');
fileName = fullfile(modelingDir, 'data_for_modeling.mat');
save(fileName, 'd_letter','criteria_letter','d_color','criteria_color','conf_corr','conf_bin','mean_conf_letter','mean_conf_color');

% Save data for matecognition analyses
type2AUC_exp1 = mean(type2AUC,2); conf_corr_exp1 = conf_corr';
metacogDir = fullfile(currentDir(1:end-length(parts{end})), 'metacog_analyses');
fileName = fullfile(metacogDir, 'metacog_exp1.mat');
save(fileName, 'type2AUC_exp1','conf_corr_exp1');