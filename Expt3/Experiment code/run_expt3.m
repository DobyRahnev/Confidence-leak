% dividedAttention_expt.m

clear all; close all;

addpath([pwd '/functions']);
startData = startExperiment('divAtten_2_vs_4_rm2');
% startData = startExperiment('divAtten_2_vs_4_test');
structName = 'startData';
unpackStructFields

win = openScreen;
HideCursor;

p = divAtten_getParameters;
Screen('FillRect',win,p.BGcolor);
Screen('Flip',win);

instructions(win);

[practiceBlockData exitNow] = runBlock(10,[.12 .14],2,0,1);
if exitNow==1, Screen('CloseAll'), ShowCursor, return, end
Screen('DrawText', win, 'You may now take a short break. Press the spacebar to continue.',p.x-100,p.y);
Screen('Flip',win);
KbWait([],2);
[practiceBlockData2 exitNow] = runBlock(10,[.12 .14],4,0,1);
if exitNow==1, Screen('CloseAll'), ShowCursor, return, end
Screen('DrawText', win, 'You may now take a short break. Press the spacebar to continue.',p.x-100,p.y);
Screen('Flip',win);
KbWait([],2);

% tGuess1 = log(.1);
% tGuessSd = 3;
% pThreshold = .75;
% beta = 3.5;
% delta = 0.01;
% gamma = 0.5;
% grain = 0.01;
% range = 5;
% 
% q = QuestCreate(tGuess1,tGuessSd,pThreshold,beta,delta,gamma,grain,range);
% 
% trialsDesired = 50;
% 
% for k=1:trialsDesired
%     ctr= exp(QuestMean(q));
%     [isAccurate isVisible direction exitNow] = runTrial(3,ctr,1);
%     if exitNow==1, Screen('CloseAll'), ShowCursor, return, end
%     q=QuestUpdate(q,log(ctr),isAccurate);
% end
% 
% q2 = QuestCreate(log(ctr),tGuessSd,pThreshold,beta,delta,gamma,grain,range);
% 
% for k=1:trialsDesired
%     ctr= exp(QuestMean(q2));
%     [isAccurate isVisible direction exitNow] = runTrial(3,ctr,1);
%     if exitNow==1, Screen('CloseAll'), ShowCursor, return, end
%     q2=QuestUpdate(q2,log(ctr),isAccurate);
% end
% 
% Screen('DrawText',win, 'Please get the experimenter.',p.x-100,p.y);
% Screen('Flip',win);
% KbWait([],2);
% 
% Screen('CloseAll');
% disp(['Suggested contrast is ' num2str(ctr)])
% try 
%     ok = input('Is this OK?  (y=1, n=0)   ');
% if isempty(ok)
%     ok = input('Is this OK?  (y=1, n=0)   ');
% end
% catch
% ok = input('Is this OK?  (y=1, n=0)   ');
% end
% if ok
%     ctrMid = ctr;
% else
%     ctrMid = .08;
% end
    
ctrMid = .08;

ctrA = ctrMid-.04;
ctrB = ctrMid-.02;
ctrC = ctrMid;
ctrD = ctrMid+.02;
ctrE = ctrMid+.04;

contrastArray = [ctrA ctrB ctrC ctrD ctrE];

Screen('FillRect',win,p.BGcolor);
Screen('Flip',win);
Screen('DrawText', win,'Press the spacebar to begin.',p.x-100,p.y);
Screen('Flip',win);
KbWait([],2);

[blockTwo1Data exitNow] = runBlock(p.nTrials,contrastArray,2,0,0);
save(dataFile);
if exitNow==1, Screen('CloseAll'), ShowCursor, return, end
Screen('DrawText', win, 'You may now take a short break. Press the spacebar to continue.',p.x-100,p.y);
Screen('Flip',win);
KbWait([],2);
[blockFour1Data exitNow]= runBlock(p.nTrials,contrastArray,4,0,0);
save(dataFile);
if exitNow==1, Screen('CloseAll'), ShowCursor, return, end
Screen('DrawText', win, 'You may now take a short break. Press the spacebar to continue.',p.x-100,p.y);
Screen('Flip',win);
KbWait([],2);
[blockTwo2Data exitNow] = runBlock(p.nTrials,contrastArray,2,0,0);
save(dataFile);
if exitNow==1, Screen('CloseAll'), ShowCursor, return, end
Screen('DrawText', win, 'You may now take a short break. Press the spacebar to continue.',p.x-100,p.y);
Screen('Flip',win);
KbWait([],2);
[blockFour2Data exitNow]= runBlock(p.nTrials,contrastArray,4,0,0);
save(dataFile);
if exitNow==1, Screen('CloseAll'), ShowCursor, return, end
Screen('DrawText', win, 'You may now take a short break. Press the spacebar to continue.',p.x-100,p.y);
Screen('Flip',win);
KbWait([],2);
[blockTwo3Data exitNow] = runBlock(p.nTrials,contrastArray,2,0,0);
save(dataFile);
if exitNow==1, Screen('CloseAll'), ShowCursor, return, end
Screen('DrawText', win, 'You may now take a short break. Press the spacebar to continue.',p.x-100,p.y);
Screen('Flip',win);
KbWait([],2);
[blockFour3Data exitNow]= runBlock(p.nTrials,contrastArray,4,0,0);
save(dataFile);
if exitNow==1, Screen('CloseAll'),  ShowCursor,return, end
Screen('DrawText', win, 'You may now take a short break. Press the spacebar to continue.',p.x-100,p.y);
Screen('Flip',win);
KbWait([],2);
[blockTwo4Data exitNow] = runBlock(p.nTrials,contrastArray,2,0,0);
save(dataFile);
if exitNow==1, Screen('CloseAll'), ShowCursor, return, end
Screen('DrawText', win, 'You may now take a short break. Press the spacebar to continue.',p.x-100,p.y);
Screen('Flip',win);
KbWait([],2);
[blockFour4Data exitNow]= runBlock(p.nTrials,contrastArray,4,0,0);
save(dataFile);
if exitNow==1, Screen('CloseAll'), ShowCursor, return, end

Screen('DrawText', win, 'Thank you for participating, press any key to exit.',p.x-100,p.y);
Screen('Flip',win);
KbWait([],2);
KbWait;

Screen('CloseAll');
ShowCursor;

save(dataFile);