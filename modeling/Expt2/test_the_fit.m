%test_the_fit

clear

%load the data
load data_for_modeling
load conf_leak_fit

%number simulations
n_trials = 100000;

% Parameters for PDF analysis
integration_window = .15;
N=1000;
y_bins_all{1} = zeros(N+1,1);
y_bins_all{2} = zeros(N+1,1);

for subject=1:length(d_VAS)
    
    subject
    
    %Simulate n_trials
    signal_optOut = d_optOut/2 + randn(n_trials,1);
    signal_VAS = d_VAS(subject)/2 + randn(n_trials,1);
    accuracy_optOut_fit = signal_optOut > 0;
    accuracy_VAS_fit = signal_VAS > 0;
    conf_VAS = give_conf(abs(signal_VAS), criteria_VAS(subject,:))-1;
    for trial=1:n_trials
        ratio = exp((conf_VAS(trial)-conf_VAS_mean(subject))*conf_leak(subject));
        conf_optOut(trial) = give_conf(abs(signal_optOut(trial)), ...
            criteria_optOut(subject) / ratio);
    end
    
    
    %% Confidence correlation
    corr_conf_fit(subject) = r2z(corr(conf_optOut', conf_VAS));
    conf_optOut_fit(subject) = mean(conf_optOut);
    conf_VAS_fit(subject) = mean(conf_VAS);
    
    
    %% Plot density of VAS as a function of opt out
    conf_VAS_adjusted = conf_VAS/100;
    x = (0:1/N:1)';
    y_bins{1} = x.*0;
    y_bins{2} = x.*0;
    for j=1:2
        vector = conf_VAS_adjusted(conf_optOut==j);
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
    
    
    %% Regression
    x = [ones(n_trials,1),...
        conf_VAS,...
        signal_VAS>0,...
        signal_optOut>0];
    B_conf(subject,:) = regress(conf_optOut',x);
    
    
    %% Compute Type 2 ROC
    stimulus = [zeros(n_trials/2,1); ones(n_trials/2,1)];
    response_VAS = (signal_VAS>0).*stimulus + (1-(signal_VAS>0)).*(1-stimulus);
    [nR_S1 nR_S2] = trials2counts(stimulus,response_VAS,conf_VAS+1, 101);
    type2AUC(subject) = type2ag(nR_S1, nR_S2, 1);
    
end

%% Check the fits
conf_leak

[corr_conf_fit' conf_corr']
mean([corr_conf_fit' conf_corr'])

[conf_VAS_mean' conf_VAS_fit']
mean([conf_VAS_mean' conf_VAS_fit'])

[conf_optOut_mean' conf_optOut_fit']
mean([conf_optOut_mean' conf_optOut_fit'])


%% Plot VAS bins as a function of opt out
% smooth = 50; %The actual moving average is 2*100*smooth/N, which is 10 for smooth=50 and N=1000
% for i=1:2
%     for j=1:length(y_bins_all{i})
%         begin = j - smooth; if begin < 1; begin = 1; end
%         ending = j + smooth; if ending > N; ending = N; end
%         y_bins_all_new{i}(j) = mean(y_bins_all{i}(begin:ending));
%     end
% end
% x = (0:1/N:1)';
% figure
% plot(100*x,y_bins_all_new{1}/length(d_VAS), 'r', 'LineWidth', 4)
% hold
% plot(100*x,y_bins_all_new{2}/length(d_VAS), 'b', 'LineWidth', 4)
% legend('Low confidence (opted out)', 'High confidence (did not opt out)');
% xlabel('Confidence on VAS');
% ylabel('Probability density');


%% Save results
% type2AUC_fit_exp2 = type2AUC';
% save metacog_fit_exp2 type2AUC_fit_exp2