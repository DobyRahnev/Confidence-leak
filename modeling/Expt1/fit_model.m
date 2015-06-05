%fit_model

clear

%load the data
load data_for_modeling

%number simulations
n_trials = 100000;

for subject=1:length(d_letter)
    
    subject
    
    %Initial conf_leak
    conf_leak=0; %parameter A in the paper
    step = .2;
    direction=1;

    while 1        
        %Simulate n_trials
        signal_letter = d_letter(subject)/2 + randn(n_trials,1);
        signal_color = d_color(subject)/2 + randn(n_trials,1);
        accuracy_letter_fit = signal_letter > 0;
        accuracy_color_fit = signal_color > 0;
        
        %Confidence on letter identity predicts confidence on color task
        conf_letter = give_conf(abs(signal_letter), criteria_letter(subject,:));
        for trial=1:n_trials
            ratio = exp((conf_letter(trial)-mean_conf_letter(subject))*conf_leak);
            conf_color(trial) = give_conf(abs(signal_color(trial)), ...
                criteria_color(subject,:) / ratio);
        end
        
        %Confidence correlation
        corr_conf_fit = r2z(corr(conf_letter, conf_color'));
        if corr_conf_fit < corr_conf(subject) - .001;
            if direction==1
                conf_leak = conf_leak + step;
            else
                direction=1;
                step = step/2;
                conf_leak = conf_leak + step;
            end
        elseif corr_conf_fit > corr_conf(subject) + .001
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
