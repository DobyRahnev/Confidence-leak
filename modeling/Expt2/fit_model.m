%fit_model

clear

%load the data
load data_for_modeling

%number simulations
n_trials = 100000;

for subject=1:length(d_VAS)
    
    subject
    
    %Initial conf_leak
    conf_leak=0;
    step = .2;
    direction=1;
    
    while 1       
        %Simulate n_trials
        signal_optOut = d_optOut/2 + randn(n_trials,1);
        signal_VAS = d_VAS(subject)/2 + randn(n_trials,1);
        accuracy_optOut_fit = signal_optOut > 0;
        accuracy_VAS_fit = signal_VAS > 0;
        conf_VAS = give_conf(abs(signal_VAS), criteria_VAS(subject,:))-1;
        for trial=1:n_trials
            ratio = exp((conf_VAS(trial)-conf_VAS_mean(subject))*conf_leak);
            conf_optOut(trial) = give_conf(abs(signal_optOut(trial)), ...
                criteria_optOut(subject) / ratio);
        end
        
        %Confidence correlation
        corr_conf_fit = r2z(corr(conf_optOut', conf_VAS));
        if corr_conf_fit < conf_corr(subject) - .001;
            if direction==1
                conf_leak = conf_leak + step;
            else
                direction=1;
                step = step/2;
                conf_leak = conf_leak + step;
            end
        elseif corr_conf_fit > conf_corr(subject) + .001
            if direction==-1
                conf_leak = conf_leak - step;
            else
                direction=-1;
                step = step/2;
                conf_leak = conf_leak - step;
            end
        else
            conf_leak_final(subject) = conf_leak;
            break
        end
    end
end

conf_leak = conf_leak_final;
%save conf_leak_fit conf_leak
