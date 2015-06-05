%analyze_conf_leak

clear

load conf_leak_fit
number_subjects = length(conf_leak);

conf_leak
mean_conf_leak = mean(conf_leak)
SD_conf_leak = std(conf_leak)
outlier_SD = (conf_leak(7)-mean(conf_leak))/std(conf_leak)
conf_leak = conf_leak([1:6,8:end]);
mean_conf_leak = mean(conf_leak)
ci_conf_leak = [mean_conf_leak - 1.96*std(conf_leak)/sqrt(number_subjects), mean_conf_leak + 1.96*std(conf_leak)/sqrt(number_subjects)]
[H P ci stats] = ttest(conf_leak)
effect_size = mean_conf_leak / std(conf_leak)