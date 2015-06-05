function [isAccurate isVisible direction exitNow] = runTrial(type,contrast,questing,feedback)

p = divAtten_getParameters;
wPtrs = Screen('Windows');
win = wPtrs(1);
validKeys1 = {'LeftArrow' 'RightArrow' 'ESCAPE'};
isAccurate = 0;
isVisible = 0;
exitNow = 0;
if ~exist('questing','var')
    questing = 0;
end

if type == 2
    direction = twoItems(contrast);
end
if type == 4
    direction = fourItems(contrast);
end

WaitSecs(.1);

fixation = makeCrosshairDestRect(p.CHsize,p.CHwidth,p.x,p.y);
Screen('FillRect',win,p.CHcolorTilt,fixation);
Screen('Flip',win);

key = recordValidKeys(GetSecs, p.ansWait, p.keyboardNumber, validKeys1);

if strcmp(key,'LeftArrow')&&direction==0
    isAccurate = 1;
end

if strcmp(key,'RightArrow')&&direction==1
    isAccurate = 1;
end

if strcmp(key,'ESCAPE')
    exitNow = 1; return;
end

if feedback == 1;
    AuditiveFeedback(isAccurate);
end

if strcmp(key,'noanswer')
    if questing==1
        isAccurate = 0;
    else
        isAccurate = -1;
    end
end

if questing==0
    Screen('FillRect',win,p.CHcolor,fixation);
    Screen('Flip',win);
    WaitSecs(.1);
    Screen('FillRect',win,p.CHcolorVis,fixation);
    Screen('Flip',win);

    validKeys2 = {'1!' '2@' 'ESCAPE'};
    key = recordValidKeys(GetSecs, p.ansWait, p.keyboardNumber, validKeys2);

    if strcmp(key,'1!')
        isVisible = 0;
    end

    if strcmp(key,'2@')
        isVisible = 1;
    end

    if strcmp(key,'ESCAPE')
        exitNow = 1; return;
    end
    
    if strcmp(key,'noanswer')
        isVisible = -1;
    end
end



Screen('Close');