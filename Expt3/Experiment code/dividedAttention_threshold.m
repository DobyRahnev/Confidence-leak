% dividedAttention_threshold.m

clear all; close all;

addpath([pwd '/functions']);
startData = startExperiment('divAtten_thresh');
structName = 'startData';
unpackStructFields
win = openScreen;
p = divAtten_getParameters;
Screen('FillRect',win,p.BGcolor);
Screen('Flip',win);

%instructions(win);

tGuess1 = log(.06);
tGress2 = log(.09);
tGuessSd = 3;
pThreshold = .75;
beta = 3.5;
delta = 0.01;
gamma = 0.5;
grain = 0.01;
range = 5;

q = QuestCreate(tGuess1,tGuessSd,pThreshold,beta,delta,gamma,grain,range);

trialsDesired = 80;

for k=1:trialsDesired
    ctr1= exp(QuestMean(q));
    [isAccurate isVisible direction exitNow] = runTrial(1,ctr1);
    if exitNow==1, Screen('CloseAll'), return, end
    q=QuestUpdate(q,log(ctr1),isAccurate);
end

fprintln('contrast 2 items = ',ctr1);

breakText = makeTextTexture(win, 'You may now take a short break. Press any key to continue.',p.BGcolor, 24);
Screen('DrawTexture',win, breakText);
Screen('Flip',win);
KbWait;

q2 = QuestCreate(tGuess2,tGuessSd,pThreshold,beta,delta,gamma,grain,range);

trialsDesired = 80;

for k=1:trialsDesired
    ctr2= exp(QuestMean(q2));
    [isAccurate isVisible direction exitNow] = runTrial(2,ctr2);
    if exitNow==1, Screen('CloseAll'), return, end
    q2=QuestUpdate(q2,log(ctr2),isAccurate);
end

fprintln('contast 4 items = ',ctr2);

endText = makeTextTexture(win, 'Please get the experimenter.',p.BGcolor, 24);
Screen('DrawTexture',win, endText);
Screen('Flip',win);
KbWait;

Screen('CloseAll');
ShowCursor;

save(dataFile);