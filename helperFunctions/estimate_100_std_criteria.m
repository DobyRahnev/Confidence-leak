function [d_prime criteria] = estimate_100_std_criteria(stim, resp, conf)

% Assume symmetrical criteria for S1 and S2
HR = sum(stim==max(stim) & resp==max(stim)) / sum(stim==max(stim));
FAR = sum(stim==min(stim) & resp==max(stim)) / sum(stim==min(stim));
d_prime = norminv(HR) - norminv(FAR);

% Correct for infinite d' values
if d_prime > 10
    d_prime = 5;
end

for conf_level=1:100
    
    percentConf = sum(conf>=conf_level) / length(conf);
    
    %Estimate the criterion location so that a certain % conf is achieved
    criterion=0;
    step=1;
    direction=1;
    while 1
        percentEstimated = 2-normcdf(criterion,-d_prime/2,1)-normcdf(criterion,d_prime/2,1);
        if percentEstimated > percentConf + .001;
            if direction==1
                criterion = criterion + step;
            else
                direction=1;
                step = step/2;
                criterion = criterion + step;
            end
        elseif percentEstimated < percentConf - .001
            if direction==-1
                criterion = criterion - step;
            else
                direction=-1;
                step = step/2;
                criterion = criterion - step;
            end
        else
            criteria(conf_level) = criterion;
            break
        end
    end
end