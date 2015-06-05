function [d_prime criteria] = std_criteria(stim, resp, conf, Nconf)

% confidence goes from 1 to N

%% Compute bins for S1 and S2 stimuli for the whole pattern of responses
% for c=1:Nconf
%     nR_S1(c) = sum(stim(resp==min(resp) & conf==Nconf+1-c)==min(stim));
%     nR_S2(c) = sum(stim(resp==min(resp) & conf==Nconf+1-c)==max(stim));
% 
%     nR_S1(Nconf+c) = sum(stim(resp==max(resp) & conf==c)==min(stim));
%     nR_S2(Nconf+c) = sum(stim(resp==max(resp) & conf==c)==max(stim));
% end
% 
% %compute HR and FAR
% ratingHR = [];
% ratingFAR = [];
% for c=2*Nconf:-1:2
%     ratingHR(end+1) = sum(nR_S2(c:end)) / sum(nR_S2);
%     ratingFAR(end+1) = sum(nR_S1(c:end)) / sum(nR_S1);
% end
% 
% d_prime = norminv(ratingHR(Nconf)) - norminv(ratingFAR(Nconf))
% criteria = -.5*(norminv(ratingHR(end:-1:1)) + norminv(ratingFAR(end:-1:1)))


%% Assume symmetrical criteria for S1 and S2
HR = sum(stim==max(stim) & resp==max(stim)) / sum(stim==max(stim));
FAR = sum(stim==min(stim) & resp==max(stim)) / sum(stim==min(stim));
d_prime = norminv(HR) - norminv(FAR);

for conf_level=2:Nconf
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
            criteria(conf_level-1) = criterion;
            break
        end
    end
end