function initial_instructions(window, width, height, p)

wrapat = p.wrapat;

%% Practice 1
text = 'Thank you for you participation in the current study!\n\nWe are interested in people''s ability to make quick perceptual decisions.\n\nPress any key to continue.';
DrawFormattedText(window, text, 300, 'center', 255, wrapat);
Screen('Flip',window);
WaitSecs(1);
KbWait;

%Task
text = 'In this study you''ll be need to judge the properties of a set of letters. More specifically, some of the letters will be X''s while the rest will be O''s. You will need to indicate whether there are more X''s or O''s. Additionally, some letters will be red, while others will be blue. You will need to indicate whether there are more blue or more red letters.\n\nPress any key to continue.';
DrawFormattedText(window, text, 300, 'center', 255, wrapat);
Screen('Flip',window);
WaitSecs(1);
KbWait;

%Confidence
text = 'After each presentation you will first need to indicate whether there are more X''s or O''s. After you select your answer, you will need to indicate your confidence on a 4-point scale. The same will be true for the second question. Let''s now do some example trials so that you get used to the task.\n\nPress any key to start a practice block.';
DrawFormattedText(window, text, 300, 'center', 255, wrapat);
Screen('Flip',window);
WaitSecs(1);
KbWait;
p.stim_duration = 3;
p.red_run = 35;
p.xes_run = 35;
number_trials = 6;

red = []; x_es = [];
perm = randperm(number_trials);
p.red{1} = ones(1,length(perm));
p.red{1}(mod(perm,2)==0) = 0;
p.x_es{1} = ones(1,length(perm));
p.x_es{1}(perm<=length(perm)/2) = 0;
one_block(window, width, height, number_trials, p);

%% Practice 2
text = 'Hopefully you are getting used to the task. The actual experiment will be a lot harder. Let''s now do some more difficult example trials in which the duration of the letters on the screen will be decreased.\n\nTry to remember the questions and what each key represents and gradually answer without looking at the questions to save time.\n\nPress any key to continue with the next practice block.';
DrawFormattedText(window, text, 300, 'center', 255, wrapat);
Screen('Flip',window);
WaitSecs(1);
KbWait;
p.stim_duration = 1;
p.red_run = 35;
p.xes_run = 35;
number_trials = 10;

red = []; x_es = [];
perm = randperm(number_trials);
p.red{1} = ones(1,length(perm));
p.red{1}(mod(perm,2)==0) = 0;
p.x_es{1} = ones(1,length(perm));
p.x_es{1}(perm<=length(perm)/2) = 0;
one_block(window, width, height, number_trials, p);

%% Practice 3
text = 'Let''s do some more example trials. Now, we''ll make the task harder by equating more the number of X''s and O''s, as well as the blue and red colors, in each trial.\n\nPress any key to continue with the next practice block.';
DrawFormattedText(window, text, 300, 'center', 255, wrapat);
Screen('Flip',window);
WaitSecs(1);
KbWait;
p.stim_duration = 1;
p.red_run = 28;
p.xes_run = 28;

red = []; x_es = [];
perm = randperm(number_trials);
p.red{1} = ones(1,length(perm));
p.red{1}(mod(perm,2)==0) = 0;
p.x_es{1} = ones(1,length(perm));
p.x_es{1}(perm<=length(perm)/2) = 0;
one_block(window, width, height, number_trials, p);


%% Practice 4
text = 'Take a short break and let''s do some more example trials. These trials should be very similar to what you will experience during the actual experiment.\n\nOne of the things that we will be interested in is your confidence ratings. Therefore, we ask you to use the whole confidence scale as much as possible. That is, try NOT to use just one or two levels of confidence but as much as possible use both ends of the scale.\n\nPress any key to continue with the next practice block.';
DrawFormattedText(window, text, 300, 'center', 255, wrapat);
Screen('Flip',window);
WaitSecs(1);
KbWait;
p.stim_duration = 1;
p.red_run = 25;
p.xes_run = 25;

red = []; x_es = [];
perm = randperm(number_trials);
p.red{1} = ones(1,length(perm));
p.red{1}(mod(perm,2)==0) = 0;
p.x_es{1} = ones(1,length(perm));
p.x_es{1}(perm<=length(perm)/2) = 0;
one_block(window, width, height, number_trials, p);

%% Practice 5
text = 'If you have any questions about the task, please ask the experimenter right now. If not, then let''s do one last practice block. During the actual experiment you will not be given feedback after each trial. You will now experience a block of trials without feedback to get used to not receiving feedback.\n\nRemember to use the whole confidence scale as much as possible. That is, try NOT to use just one or two levels of confidence but as much as possible use both ends of the scale.\n\nPress any key to continue with the final practice block.';
DrawFormattedText(window, text, 300, 'center', 255, wrapat);
Screen('Flip',window);
WaitSecs(1);
KbWait;
p.stim_duration = 1;
p.red_run = 25;
p.xes_run = 25;
p.feedback = 0;

red = []; x_es = [];
perm = randperm(number_trials);
p.red{1} = ones(1,length(perm));
p.red{1}(mod(perm,2)==0) = 0;
p.x_es{1} = ones(1,length(perm));
p.x_es{1}(perm<=length(perm)/2) = 0;
one_block(window, width, height, number_trials, p);