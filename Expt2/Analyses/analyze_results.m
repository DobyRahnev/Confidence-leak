%analyze_results

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Analysis of Experiment 2
%
% This code recreates all the analyses from our manuscript.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear

%Bad subjects: subjects that opted out extreme amounts:
%S10: 400/400
%S9: 396/400
%S8: 1/400
%S5: 5/400
selected_subjects = [1:4,6,7,11:22];
number_subjects = length(selected_subjects);
addpath(genpath(fullfile(pwd, 'helperFunctions')));

% Parameters for PDF analysis
integration_window = .15;
N=1000;
y_bins_all{1} = zeros(N+1,1);
y_bins_all{2} = zeros(N+1,1);

% Loop through all subjects
for subject_number=1:number_subjects
    
    
    %% Load the data
    file_name = ['data/results_s' num2str(selected_subjects(subject_number)) ''];
    eval(['load ' file_name '']);
    number_blocks = size(p.rt,1);
    number_trials_per_block = size(p.rt,2);
    
    
    %% Figure out task ordering and compute basic vectors
    VAS = (1-p.task1_is_scale)*3+1; %1: first task is VAS; 4: second task is VAS
    opt_out = 5 - VAS; %1: first task is opt out; 4: second task is opt out
    color = (1-p.task1_is_color)*3+1; %1: first task is color; 4: second task is color
    letter = 5 - color; %1: first task is letter identity; 4: second task is letter identity
    
    %Compute stimulus for VAS
    if p.task1_is_scale == p.task1_is_color %VAS is color
        stimulus_VAS = 1 - [p.red{1}, p.red{2}, p.red{3}, p.red{4}]'; %0:red, 1:blue
    else
        stimulus_VAS = 1 - [p.x_es{1}, p.x_es{2}, p.x_es{3}, p.x_es{4}]'; %0:X, 1:O
    end
    
    %VAS vs. opt out
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
    
    %Color vs. letter identity
    acc_color = reshape(p.answers(:,:,color+2)',400,1);
    acc_letter = reshape(p.answers(:,:,letter+2)',400,1);
    conf_color = reshape(p.answers(:,:,color+1)',400,1);
    conf_letter = reshape(p.answers(:,:,letter+1)',400,1);
    response_color = reshape(p.answers(:,:,color)',400,1) - 1; %0:red, 1:blue
    response_letter = reshape(p.answers(:,:,letter)',400,1) - 1; %0:X, 1:O 
    
    
    %% Compute basic values
    conf_twoTasks(subject_number,:) = mean([conf_VAS, conf_optOut]);
    conf_optOut_mean(subject_number) = mean(conf_optOut)-1;
    conf_VAS_mean(subject_number) = 100*mean(conf_VAS);
    acc_twoTasks(subject_number,:) = [mean(acc_VAS), mean(acc_optOut(acc_optOut<9))];
    total_points(subject_number) = p.total_points;
    for i=1:2
        conf_VAS_depending_on_optOut(subject_number,i) = mean(conf_VAS(conf_optOut==i));
    end
    [d_VAS(subject_number), criteria_VAS(subject_number,:)] = estimate_100_std_criteria(stimulus_VAS, response_VAS, round(100*conf_VAS));
    
    
    %% Correlation between tasks
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
    
    
    %% Regression
    if p.task1_is_color == p.task1_is_scale
        diff_VAS = reshape(p.color_diff',400,1); %1: difficult, 2: easy
        diff_optOut = reshape(p.xo_diff',400,1); %1: difficult, 2: easy
    else
        diff_VAS = reshape(p.xo_diff',400,1); %1: difficult, 2: easy
        diff_optOut = reshape(p.color_diff',400,1); %1: difficult, 2: easy
    end
    x = [ones(400,1),...
        conf_VAS, ... %confidence on VAS task
        acc_VAS, ...
        acc_optOut,...
        rt_VAS,...
        rt_optOut,...
        diff_VAS,...
        diff_optOut];
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


%% Save results for modeling
% d_optOut = mean(d_VAS);
% for subject=1:number_subjects
%     criteria_optOut(subject) = std_criteria_from_dprime(d_optOut, conf_optOut_mean(subject), 2);
% end
% save data_for_modeling d_VAS d_optOut criteria_VAS criteria_optOut conf_VAS_mean conf_optOut_mean conf_corr


%% Confidence leak
mean_conf_corr = mean(conf_corr)
sum(p_ind_conf < .05)
ci_conf_corr = [mean_conf_corr - 1.96*std(conf_corr)/sqrt(number_subjects), mean_conf_corr + 1.96*std(conf_corr)/sqrt(number_subjects)]
[H P ci stats] = ttest(conf_corr)
effect_size = mean_conf_corr / std(conf_corr)

% Compute Bayes factor
distribParams.mean = 0;
distribParams.SD = 1;
distribParams.tail = 1;
BayesFactor = bayes_factor(conf_corr, 0, distribParams)


%% Confidence Regression
% mean_conf_regr = mean(B_conf(:,2))
% ci_conf_corr = [mean_conf_regr - 1.96*std(B_conf(:,2))/sqrt(number_subjects), mean_conf_regr + 1.96*std(B_conf(:,2))/sqrt(number_subjects)]
% [H P ci stats] = ttest(B_conf);
% P


%% Accuracy leak
% %Results when restricted to trials with high confidence on the opt out task
% mean(accu_corr_highConfOnOptOut)
% [H P ci stats] = ttest(accu_corr_highConfOnOptOut)
% effect_size = mean(accu_corr_highConfOnOptOut / std(accu_corr_highConfOnOptOut))
% 
% %Results when restricted to trials with high confidence on both tasks
% accu_corr_highConfOnBoth = accu_corr_highConfOnBoth(2:end); %remove NaN value for S1
% mean(accu_corr_highConfOnBoth)
% [H P ci stats] = ttest(accu_corr_highConfOnBoth)
% effect_size = mean(accu_corr_highConfOnBoth / std(accu_corr_highConfOnBoth))
% 
% %Stats on relationship between accuracy and confidence leak
% [r p] = corr(conf_corr', accu_corr_highConfOnOptOut')
% numSubjAdjusted = number_subjects - 1; %adjust for removing S1
% CI = z2r([r2z(r) - 1.96/sqrt(numSubjAdjusted-3), r2z(r) + 1.96/sqrt(numSubjAdjusted-3)])


%% Plot individual fits of confidence correlation
% figure
% conf_VAS_depending_on_optOut = conf_VAS_depending_on_optOut *100;
% ax = axes;
% plot([1 2], [conf_VAS_depending_on_optOut(1,1), conf_VAS_depending_on_optOut(1,2)], 'k-', 'LineWidth', 2);
% hold
% for i=2:number_subjects
%     plot([1 2], [conf_VAS_depending_on_optOut(i,1), conf_VAS_depending_on_optOut(i,2)], 'k-', 'LineWidth', 2);
% end
% xlabel('Confidence on opt-out task', 'FontSize',30)
% ylabel('Confidence on VAS', 'FontSize',30);
% xlim([1, 2]);
% ylim([0 100]);
% set(ax,'XTick',1:2);
% set(ax,'YTick',0:20:100);
% axis('square')


%% Plot VAS bins as a function of opt out
% smooth = 50; %The actual moving average is 2*100*smooth/N, which is 10 for smooth=50 and N=1000
% for i=1:2
%     for j=1:length(y_bins_all{i})
%         begin = j - smooth; if begin < 1; begin = 1; end
%         ending = j + smooth; if ending > N; ending = N; end
%         y_bins_all_new{i}(j) = mean(y_bins_all{i}(begin:ending));
%     end
% end
% figure
% plot(100*x,y_bins_all_new{1}/number_subjects, 'r', 'LineWidth', 4)
% hold
% plot(100*x,y_bins_all_new{2}/number_subjects, 'b', 'LineWidth', 4)
% legend('Low confidence (opted out)', 'High confidence (did not opt out)');
% xlabel('Confidence on VAS');
% ylabel('Probability density');


%% Correlation between confidence leak and metacognition
% [r p] = corr(mean(type2AUC,2), conf_corr')
% CI = z2r([r2z(r) - 1.96/sqrt(number_subjects-3), r2z(r) + 1.96/sqrt(number_subjects-3)])
% 
% % Save data to be analyzed together with Experiments 2 and 3
% type2AUC_exp2 = type2AUC; conf_corr_exp2 = conf_corr';
% save metacog_exp2 type2AUC_exp2 conf_corr_exp2