function initial_instructions(window, width, height, p)

wrapat = p.wrapat;
p.total_points = 0;

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

%Points 
text = 'You will earn points for both the X/O and red/blue tasks. Each correct answer will give you 3 points, while each wrong answer will result in 0 points. The 3 participants with highest score in the end of the experiment will receive an additional $10 bonus, so try your best!\n\nFor one of the questions you''ll need to use the keyboard. For that question you will have the additional option of choosing to "opt out" and not select an answer. If you choose that option, you will have guaranteed 2 points.\n\nFor the other question you''ll respond with the mouse and won''t have the opportunity to "opt out". After responding to that question you will be asked to give a confidence rating on a continuous scale with the mouse.\n\nLet''s now do some example trials so that you get used to the task.\n\nPress any key to start a practice block.';
DrawFormattedText(window, text, 300, 'center', 255, wrapat);
Screen('Flip',window);
WaitSecs(1);
KbWait;
p.stim_duration = 3;
p.red_values = [35 35];
p.xo_values = [35 35];
number_trials = 6;

red = []; x_es = [];
perm = randperm(number_trials);
p.red{1} = ones(1,length(perm));
p.red{1}(mod(perm,2)==0) = 0;
p.x_es{1} = ones(1,length(perm));
p.x_es{1}(perm<=length(perm)/2) = 0;
one_block(window, width, height, number_trials, p);

%% Practice 2
text = 'Hopefully you are getting used to the task. The actual experiment will be a lot harder. Let''s now do some more difficult example trials in which the duration of the letters on the screen will be decreased.\n\nRemember, you get 3 points for a correct answer, 0 for a wrong answer, and 2 points if you choose to opt out. In that task the optimal strategy is to choose the "Opt Out" option if you are less than 67% certain in your response.\n\nAs you may have noticed, if your mouse click is outside the box, then the computer will just choose the closer box to where your mouse click occured. Your selected answer will be indicated by the frame of that answer changing color to red for a brief moment. If you click outside of the continuous scale, the computer will choose the closest possible point on the scale. A big red dot will indicate where your response was recorded.\n\nPress any key to continue with the next practice block.';
DrawFormattedText(window, text, 300, 'center', 255, wrapat);
Screen('Flip',window);
WaitSecs(1);
KbWait;
p.stim_duration = 1;
p.red_values = [30 30];
p.xo_values = [30 30];
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
p.red_values = [26 29];
p.xo_values = [26 29];

red = []; x_es = [];
perm = randperm(number_trials);
p.red{1} = ones(1,length(perm));
p.red{1}(mod(perm,2)==0) = 0;
p.x_es{1} = ones(1,length(perm));
p.x_es{1}(perm<=length(perm)/2) = 0;
one_block(window, width, height, number_trials, p);


%% Practice 4
text = 'Take a short break and let''s do some more example trials. These trials should be very similar to what you will experience during the actual experiment.\n\nOne of the things that we will be interested in is your confidence ratings that you give on the continuous scale. Therefore, we ask you to use the whole confidence scale as much as possible. Failure to comply with this may disqualify you from earning the $10 bonus.\n\nPress any key to continue with the next practice block.';
DrawFormattedText(window, text, 300, 'center', 255, wrapat);
Screen('Flip',window);
WaitSecs(1);
KbWait;
p.stim_duration = 1;
p.red_values = [23 26];
p.xo_values = [23 26];

red = []; x_es = [];
perm = randperm(number_trials);
p.red{1} = ones(1,length(perm));
p.red{1}(mod(perm,2)==0) = 0;
p.x_es{1} = ones(1,length(perm));
p.x_es{1}(perm<=length(perm)/2) = 0;
one_block(window, width, height, number_trials, p);

%% Practice 5
text = 'If you have any questions about the task, please ask the experimenter right now. If not, then let''s do one last practice block. During the actual experiment you will not be given feedback after each trial. You will now experience a block of trials without feedback to get used to not receiving feedback.\n\nRemember to use the whole confidence scale as much as possible, and to choose the "Opt Out" option when you are less than 67% correct in your response.\n\nPress any key to continue with the final practice block.';
DrawFormattedText(window, text, 300, 'center', 255, wrapat);
Screen('Flip',window);
WaitSecs(1);
KbWait;
p.stim_duration = 1;
p.red_values = [23 26];
p.xo_values = [23 26];
p.feedback = 0;

red = []; x_es = [];
perm = randperm(number_trials);
p.red{1} = ones(1,length(perm));
p.red{1}(mod(perm,2)==0) = 0;
p.x_es{1} = ones(1,length(perm));
p.x_es{1}(perm<=length(perm)/2) = 0;
one_block(window, width, height, number_trials, p);