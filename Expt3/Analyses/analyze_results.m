%analyze_results

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Analysis of Experiment 3
%
% This code recreates all the analyses from our manuscript.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear

% Subjects
subjects = 1:20;
number_subjects = length(subjects);
addpath(genpath(fullfile(pwd, 'helperFunctions')));

% Loop through all subjects
for subject_number=1:number_subjects
    
    %% Load the data
    file_name = ['data/divAtten_2_vs_4_rm2_S' num2str(subject_number) ''];
    eval(['load ' file_name '']);
    
    
    %% Compile all data in one variable
    %data organization:
    %data(i,1) = trial type: 2 vs. 4
    %data(i,2) = contrast
    %data(i,3) = stimulus identity
    %data(i,4) = accuracy
    %data(i,5) = confidence
    data_init{1} = blockTwo1Data;
    data_init{2} = blockTwo2Data;
    data_init{3} = blockTwo3Data;
    data_init{4} = blockTwo4Data;
    data_init{5} = blockFour1Data;
    data_init{6} = blockFour2Data;
    data_init{7} = blockFour3Data;
    data_init{8} = blockFour4Data;
    data_all = [];
    
    
    %% Clean the data from trials without responses
    for block=1:8
        data{block} = [];
        for i=1:size(data_init{block},1)
            if data_init{block}(i,4) ~= -1 && data_init{block}(i,5) ~= -1
                data{block}(end+1,:) = data_init{block}(i,:);
            end
        end
        data_all = [data_all; data{block}];
        data_by_cond{1} = data_all(data_all(:,1)==2,:);
        data_by_cond{2} = data_all(data_all(:,1)==4,:);
    end
    
    
    %% Compute SDT variables for all trials
    output_two = data_analysis(data_all(data_all(:,1)==2,3), data_all(data_all(:,1)==2,4));
    output_four = data_analysis(data_all(data_all(:,1)==4,3), data_all(data_all(:,1)==4,4));
    d_prime2(subject_number) = output_two.d_prime;
    d_prime4(subject_number) = output_four.d_prime;
    criterion2(subject_number) = std_criteria_from_dprime(output_two.d_prime, mean(data_all(data_all(:,1)==2,5)), 2);
    criterion4(subject_number) = std_criteria_from_dprime(output_four.d_prime, mean(data_all(data_all(:,1)==4,5)), 2);
    conf2(subject_number) = mean(data_all(data_all(:,1)==2,5));
    conf4(subject_number) = mean(data_all(data_all(:,1)==4,5));

    
    %% Simple correlations
    [corr_conf_raw(subject_number) p_conf_corr(subject_number)] = corr(data_all(1:end-1,5), data_all(2:end,5));
    conf_corr(subject_number) = r2z(corr(data_all(1:end-1,5), data_all(2:end,5)));
    
    
    %% Do regressions
    % standard regression
    x = [ones(size(data_all,1)-1,1),...
        data_all(1:end-1,5), ... %prev confidence
        data_all(1:end-1,4),... %prev accuracy
        data_all(2:end,4)]; %current accuracy
    B_conf(subject_number,:) = regress(data_all(2:end,5),x);
    
    % regression for 2 vs. 4 separately
    for cond=1:2
        x = [ones(size(data_by_cond{cond},1)-1,1),...
            data_by_cond{cond}(1:end-1,5), ... %prev confidence
            data_by_cond{cond}(1:end-1,4), ... %prev accuracy
            data_by_cond{cond}(2:end,4),... %current accuracy
            data_by_cond{cond}(1:end-1,2),... %prev contrast (task difficulty)
            data_by_cond{cond}(2:end,2)]; %current contrast (task difficulty)
        B_conf_cond(subject_number,:,cond) = regress(data_by_cond{cond}(2:end,5),x);
    end
    
    
    %% Confidence on current trial as a function of previous trial
    conf_bin(subject_number,1) = sum((1-data_all(1:end-1,5)).*data_all(2:end,5))/sum(1-data_all(1:end-1,5));
    conf_bin(subject_number,2) = sum(data_all(1:end-1,5).*data_all(2:end,5))/sum(data_all(1:end-1,5));
    
    
    %% Compute Type 2 AUC
    stim = data_all(:,3);
    resp = data_all(:,3) == data_all(:,4);
    conf = data_all(:,5);
    [nR_S1 nR_S2] = trials2counts(stim, resp, conf+1, 2);
    type2AUC(subject_number) = type2ag(nR_S1, nR_S2, 1);    
    
end

%% Save data for modeling
%save data_for_modeling d_prime2 d_prime4 criterion2 criterion4 conf2 conf4 conf_corr


%% Display basic results
% mean(d_prime2)
% mean(d_prime4)
% [H P ci stats] = ttest(d_prime2, d_prime4)


%% Confidence leak: Coorelation analysis
conf_corr
mean_conf_corr = mean(conf_corr)
ci_conf_corr = [mean_conf_corr - 1.96*std(conf_corr)/sqrt(number_subjects), mean_conf_corr + 1.96*std(conf_corr)/sqrt(number_subjects)]
[H P ci stats] = ttest(conf_corr)
effect_size = mean_conf_corr / std(conf_corr)

% Compute Bayes factor
distribParams.mean = 0;
distribParams.SD = 1;
distribParams.tail = 1;
BayesFactor = bayes_factor(conf_corr, 0, distribParams)


%% Confidence leak: Regression analysis
% B_conf(:,2)
% mean_conf_regr = mean(B_conf(:,2))
% ci_conf_corr = [mean_conf_regr - 1.96*std(B_conf(:,2))/sqrt(number_subjects), mean_conf_regr + 1.96*std(B_conf(:,2))/sqrt(number_subjects)]
% [H P ci stats] = ttest(B_conf(:,2))


%% Role of attention: Regression analyses for 2 vs. 4 stimulus conditions
% mean(B_conf_cond(:,2,:))
% mean_conf_regr = mean(B_conf_cond(:,2,:))
% [H P ci stats] = ttest(B_conf_cond(:,2,1), B_conf_cond(:,2,2))


%% Figure 5B and 5D
% plot_consecutive_bars([d_prime2; d_prime4], 'd''')
% plot_consecutive_bars([B_conf_cond(:,2,1), B_conf_cond(:,2,2)], 'Confidence leak')


%% Figure 5C: Plot individual fits of confidence correlation
% figure
% conf_bin = conf_bin+1;
% ax = axes;
% plot([1 2], [conf_bin(1,1), conf_bin(1,2)], 'k-', 'LineWidth', 2);
% hold
% for i=2:number_subjects
%     plot([1 2], [conf_bin(i,1), conf_bin(i,2)], 'k-', 'LineWidth', 2);
% end
% xlabel('Confidence (Opt Out)', 'FontSize',30)
% ylabel('Confidence (Rating)', 'FontSize',30);
% xlim([1, 2]);
% ylim([1 2]);
% set(ax,'XTick',1:2);
% set(ax,'YTick',1:2);
% axis('square')


%% Correlation between confidence leak and metacognition
[r p] = corr(type2AUC', conf_corr')
CI = z2r([r2z(r) - 1.96/sqrt(number_subjects-3), r2z(r) + 1.96/sqrt(number_subjects-3)])

% Save data to be analyzed together with Experiments 2 and 3
% type2AUC_exp3 = type2AUC'; conf_corr_exp3 = conf_corr';
% save metacog_exp3 type2AUC_exp3 conf_corr_exp3