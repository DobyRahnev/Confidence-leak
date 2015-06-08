%compute_autoNregress

clear

allFiles = dir('data/gf2AFC*.mat');

for sub=1:34
    subID{sub} = allFiles((sub-1)*6+1).name(7:12);
    x=[];y=[];
    for block=1:5
        load(['data/' allFiles((sub-1)*6+block+1).name]);
        [min(data.rating), max(data.rating)]
        correct(block,:) = data.correct;
        rt(block,:) = data.responseRT;
        conf(block,:) = data.rating;
        contrast(block,:) = data.contrastLevel;
        auto(sub,block) = r2z(corr(data.rating(1:end-1)', data.rating(2:end)'));
        x = [x; ones(length(data.rating)-1,1), ...
            data.rating(1:end-1)', ...
            data.correct(1:end-1)', ...
            data.correct(2:end)', ...
            data.responseRT(1:end-1)', ...
            data.responseRT(2:end)', ...
            data.contrastLevel(1:end-1)', ...
            data.contrastLevel(2:end)'];
        y = [y; data.rating(2:end)'];
    end
    
    %compute autocorelation
    previous = [];
    current = [];
    for block=1:size(conf,1)
        previous = [previous; conf(block, 1:end-1)'];
        current = [current; conf(block, 2:end)'];
    end    
    autocorr(sub) = r2z(corr(previous, current));
    
    %compute regression
    B_conf(sub,:) = regress(y,x);
        
end

%autocorrelation
autocorr = autocorr'
mean(autocorr)

%consistency of the autocorrelation over the 5 blocks
[r p]=corr(auto,auto)

%regression
B_conf
mean(B_conf)
[h p]=ttest(B_conf)
conf_leak = B_conf(:,2);

%relationship between autocorrelation and regression
[r p] = corr(autocorr,B_conf(:,2))
%plot(autocorr',B_conf(:,2),'*')

%save conf_leak_percept subID conf_leak autocorr