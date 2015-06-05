%analyze_results

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Analysis of Experiment 1
%
% The experiment included 2 tasks: X/O (first) and red/blue (second). The
% X/O task always had the same difficulty, while red/blue task changed in
% difficulty between the 4 runs.
%
% This code recreates all the analyses from our manuscript.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear

% Select subjects (S9 is completely at chance)
selected_subjects = [1:8,10:27];
number_subjects = length(selected_subjects);

% Initialize some parameters
prev_conf1 = []; prev_conf4=[];
subj_for_other14_analysis=[];
addpath(genpath(fullfile(pwd, 'helperFunctions')));


% Loop through all subjects
for subject_number=1:number_subjects
    
    %Load the data
    file_name = ['data/results_s' num2str(selected_subjects(subject_number)) ''];
    eval(['load ' file_name '']);
    
    %Size of blocks and runs
    number_blocks = size(p.rt,1);
    number_trials_per_block = size(p.rt,2);
    
    
    %% Set the order of the easy and difficult runs
    if p.red_run(1) == 23
        order(subject_number) = 1;
        hard = [1,3];
        easy = [2,4];
        difficulty = [2*ones(100,1);ones(100,1);2*ones(100,1);ones(100,1)];
    else
        order(subject_number) = 2;
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
    confidence{1} = reshape(p.answers(:,:,2)',400,1); %X/O
    confidence{2} = reshape(p.answers(:,:,5)',400,1); %red/blue
    accuracy{1} = reshape(p.answers(:,:,3)',400,1); %X/O
    accuracy{2} = reshape(p.answers(:,:,6)',400,1); %red/blue
    rt{1} = reshape(p.rt(:,:,1)',400,1) - 1;
    rt{2} = reshape(p.rt(:,:,3)',400,1) - reshape(p.rt(:,:,2)',400,1) - .3;
    mean_rt(subject_number, :) = mean(mean(p.rt,2));
    
    
    %% Simple correlations
    [corr_conf_raw(subject_number) p_conf_corr(subject_number)] = corr(confidence{1}, confidence{2});
    corr_conf(subject_number) = r2z(corr(confidence{1}, confidence{2}));
    corr_accuracy(subject_number) = r2z(corr(accuracy{1}, accuracy{2}));
    
    
    %% Regression on confidence
    x = [ones(400,1),...
        confidence{1},...
        accuracy{1},...
        accuracy{2},...
        rt{1},...
        rt{2},...
        difficulty];
    regressCoef(subject_number,:) = regress(confidence{2},x);
    
    x = [ones(400,1),...
        confidence{1}];
    regressCoef_forPlot(subject_number,:) = regress(confidence{2},x);
    
    
    %% Count the number of each confidence response (1-4) for the color task (second task) as a funciton of letter task
    for i=1:4
        conf_bin(subject_number,i) = mean(confidence{2}(confidence{1}==i));
    end
    for i=1:2
        d_bin(subject_number,i) = std_criteria(stimulus{2}(accuracy{1}==2-i), response{2}(accuracy{1}==2-i), confidence{2}(accuracy{1}==2-i), 4);
    end
    
    
    %% Correlations over different timescales (Nikolic et al)
    scales = [5, 10, 20, 50, 100, 200, 400];
    num_scales = length(scales);
    for i=1:length(scales)
        scaled_r(subject_number,i) = r2z(scaled_correlation(confidence{1}, confidence{2}, scales(i)));
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

%% Save results for modeling
save data_for_modeling d_letter criteria_letter d_color criteria_color corr_conf conf_bin mean_conf_letter mean_conf_color


%% Basic results: percent correct and confidence
mean_accuracy_letterTask = mean(accuracy_letter)
mean_accuracy_colorTask = mean(accuracy_color)
mean_conf_letterTask = mean(confidence_letter)
mean_conf_colorTask = mean(confidence_color)

mean_accuracy_colorTask_difficulty = mean(accuracy_color_difficulty)
mean_conf_colorTask_difficulty = mean(confidence_color_difficulty)


%% Confidence leak: Coorelation analysis
corr_conf
mean_conf_corr = mean(corr_conf)
sum(p_conf_corr<.05)
ci_conf_corr = [mean_conf_corr - 1.96*std(corr_conf)/sqrt(number_subjects), mean_conf_corr + 1.96*std(corr_conf)/sqrt(number_subjects)]
[H P ci stats] = ttest(corr_conf)
effect_size = mean_conf_corr / std(corr_conf)

% Compute Bayes factor
distribParams.mean = 0;
distribParams.SD = 1;
distribParams.tail = 1;
BayesFactor = bayes_factor(corr_conf, 0, distribParams)


%% Confidence leak: Regression analysis
regressCoef(:,2)
mean_conf_regr = mean(regressCoef(:,2))
ci_conf_corr = [mean_conf_regr - 1.96*std(regressCoef(:,2))/sqrt(number_subjects), mean_conf_regr + 1.96*std(regressCoef(:,2))/sqrt(number_subjects)]
[H P ci stats] = ttest(regressCoef(:,2))

% Repeated measures ANOVA
conf_regr = reshape(repmat(1:4,number_subjects,1),4*number_subjects,1);
subject = repmat([1:number_subjects]',4,1);
x = {conf_regr,subject};
anovan(reshape(conf_bin,4*number_subjects,1),x,'model','full','random',2) % look at the main effects of X1

% Control analyses for accuracy and RT
[H P ci stats] = ttest(regressCoef);
P %P(3) and P(5) test for the ability of accuracy and RT on color identity task to predict confidence on the color task


%% Test of attentional fluctuations
% Stats on accuracy leak
mean(d_bin)
[H P ci stats] = ttest(d_bin(:,1) - d_bin(:,2))
effect_size = mean(d_bin(:,1) - d_bin(:,2)) / mean(std(d_bin))

%Stats on relationship between accuracy and confidence leak
[r p] = corr(corr_conf', d_bin(:,1)-d_bin(:,2))


%% Confidence correlation as a function of window length (scaled correlation, Nikolic et al)
% Repeated measures ANOVA on the differences between the correlations
corr_window = reshape(repmat(1:num_scales,number_subjects,1),num_scales*number_subjects,1);
subject = repmat([1:number_subjects]',num_scales,1);
x = {corr_window,subject};
anovan(reshape(scaled_r,num_scales*number_subjects,1),x,'model','full','random',2); % look only at the main effects of X1


%% Causal test of changing difficulty on color task for accuracy and confidence on letter identity task
[H P ci stats] = ttest(accuracy_easyDiff(:,1), accuracy_easyDiff(:,2))
[H P ci stats] = ttest(confidence_easyDiff(:,1), confidence_easyDiff(:,2))


%% Response priming control: Response pattern for '1' and '4' responses without repetitions
mean(prev_conf1)
mean(prev_conf4)

% Do repeated measures ANOVA
conf_regr = reshape(repmat([1:3,1:3],length(prev_conf1),1),6*length(prev_conf1),1);
conf_on_prev = [ones(3*length(prev_conf1),1); 2*ones(3*length(prev_conf1),1)];
subject = repmat([1:length(prev_conf1)]',6,1);
x = {conf_regr,conf_on_prev,subject};
y = [reshape(prev_conf1,3*length(prev_conf1),1); reshape(prev_conf4,3*length(prev_conf1),1)];
anovan(y,x,'model','full','random',3); %look at interaction between X1 and X2

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


%% Correlation between confidence leak and metacognition
[r p] = corr(mean(type2AUC,2), corr_conf')
CI = z2r([r2z(r) - 1.96/sqrt(number_subjects-3), r2z(r) + 1.96/sqrt(number_subjects-3)])

% Save data to be analyzed together with Experiments 2 and 3
type2AUC_exp1 = type2AUC; conf_corr_exp1 = corr_conf';
save metacog_exp1 type2AUC_exp1 conf_corr_exp1