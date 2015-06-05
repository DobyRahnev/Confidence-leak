function criteria = std_criteria_from_dprime(d_prime, percentConf, Nconf)

% confidence goes from 1 to N

for conf_level=2:Nconf
    
    %Estimate the criterion location so that a certain % conf is achieved
    criterion=0;
    step=1;
    direction=1;
    while 1
        percentEstimated = 2-normcdf(criterion,-d_prime/2,1)-normcdf(criterion,d_prime/2,1);
        if percentEstimated > percentConf(conf_level-1) + .001;
            if direction==1
                criterion = criterion + step;
            else
                direction=1;
                step = step/2;
                criterion = criterion + step;
            end
        elseif percentEstimated < percentConf(conf_level-1) - .001
            if direction==-1
                criterion = criterion - step;
            else
                direction=-1;
                step = step/2;
                criterion = criterion - step;
            end
        else
            criteria(conf_level-1) = criterion;
            break
        end
    end
end