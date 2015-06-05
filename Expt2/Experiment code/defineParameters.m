function p = defineParameters(p)
%% Get current time
current_time = clock;
p.text_results = ['results' num2str(current_time(3)) '_' num2str(current_time(4)) '_' num2str(current_time(5)) ''];

%% Reset the rand function
%RandStream.setDefaultStream(RandStream('mt19937ar','seed',sum(100*clock)));
rand('twister',sum(10*clock));
%rand('state',sum(100.*clock));

%% Define the parameters for the experiment
p.stim_duration = 1;
p.total_points = 0;

p.number_runs = 4;
p.number_blocks = 4;
p.trials_per_block = 25;
p.currentTrial = 1;

p.red_values = [23 26];
p.xo_values = [23 26];

red = []; x_es = [];
for i=1:p.number_runs
    perm = randperm(p.number_blocks * p.trials_per_block);
    p.red{i} = ones(1,length(perm));
    p.red{i}(mod(perm,2)==0) = 0;
    p.x_es{i} = ones(1,length(perm));
    p.x_es{i}(perm<=length(perm)/2) = 0;
end