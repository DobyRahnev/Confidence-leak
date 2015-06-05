function direction = fourItems(contrast)

wPtrs = Screen('Windows');
win = wPtrs(1);
p = divAtten_getParameters;

if rand<.5
    tilt = 135;
    direction = 0;
else
    tilt = 45;
    direction = 1;
end

width = 32;
nGaussianSDs = 6;
contrastFraction = contrast;
gratingPeriod = 6;
gratingPeriodUnits = [];
orientation = 'vertical';
black = [];
white = [];

gaborPatch = makeGaborPatch(width,nGaussianSDs,contrastFraction,gratingPeriod,gratingPeriodUnits,orientation,black,white);
gaborTex = Screen('MakeTexture', win, gaborPatch);
fixation = makeCrosshairDestRect(p.CHsize,p.CHwidth,p.x,p.y);
Screen('FillRect',win,p.CHcolor,fixation);
Screen('Flip',win);
WaitSecs(p.fixationTime);

n = 8;
f = ceil(n.*rand);

if f == 1
    Screen('FillRect',win,p.CHcolor,fixation);
    Screen('DrawTexture',win,gaborTex,[],CenterRectOnPoint(p.gaborRect, p.x-((p.gaborDist)/sqrt(2)), p.y-((p.gaborDist)/sqrt(2))),tilt);
    Screen('DrawTexture',win,gaborTex,[],CenterRectOnPoint(p.gaborRect, p.x+((p.gaborDist)/sqrt(2)), p.y-((p.gaborDist)/sqrt(2))),generateTilt());
    Screen('DrawTexture',win,gaborTex,[],CenterRectOnPoint(p.gaborRect, p.x-((p.gaborDist)/sqrt(2)), p.y+((p.gaborDist)/sqrt(2))),generateTilt());
    Screen('DrawTexture',win,gaborTex,[],CenterRectOnPoint(p.gaborRect, p.x+((p.gaborDist)/sqrt(2)), p.y+((p.gaborDist)/sqrt(2))),generateTilt());
    Screen('Flip', win);
    WaitSecs(p.presentationTime);
    Screen('FillRect',win,p.CHcolor,fixation);
    Screen('Flip',win);
    WaitSecs(p.untilCueTime);
    Screen('FillRect',win,p.CHcolor,fixation);
    Screen('FrameOval',win,p.CHcolor, CenterRectOnPoint(p.gaborRect, p.x-((p.gaborDist)/sqrt(2)), p.y-((p.gaborDist)/sqrt(2))));
    Screen('Flip',win);
end
if f == 2
    Screen('FillRect',win,p.CHcolor,fixation);
    Screen('DrawTexture',win,gaborTex,[],CenterRectOnPoint(p.gaborRect, p.x-((p.gaborDist)/sqrt(2)), p.y-((p.gaborDist)/sqrt(2))),generateTilt());
    Screen('DrawTexture',win,gaborTex,[],CenterRectOnPoint(p.gaborRect, p.x+((p.gaborDist)/sqrt(2)), p.y-((p.gaborDist)/sqrt(2))),tilt);
    Screen('DrawTexture',win,gaborTex,[],CenterRectOnPoint(p.gaborRect, p.x-((p.gaborDist)/sqrt(2)), p.y+((p.gaborDist)/sqrt(2))),generateTilt());
    Screen('DrawTexture',win,gaborTex,[],CenterRectOnPoint(p.gaborRect, p.x+((p.gaborDist)/sqrt(2)), p.y+((p.gaborDist)/sqrt(2))),generateTilt());
    Screen('Flip', win);
    WaitSecs(p.presentationTime);
    Screen('FillRect',win,p.CHcolor,fixation);
    Screen('Flip',win);
    WaitSecs(p.untilCueTime);
    Screen('FillRect',win,p.CHcolor,fixation);
    Screen('FrameOval',win,p.CHcolor, CenterRectOnPoint(p.gaborRect, p.x+((p.gaborDist)/sqrt(2)), p.y-((p.gaborDist)/sqrt(2))));
    Screen('Flip',win);
end
if f == 3
    Screen('FillRect',win,p.CHcolor,fixation);
    Screen('DrawTexture',win,gaborTex,[],CenterRectOnPoint(p.gaborRect, p.x-((p.gaborDist)/sqrt(2)), p.y-((p.gaborDist)/sqrt(2))),generateTilt());
    Screen('DrawTexture',win,gaborTex,[],CenterRectOnPoint(p.gaborRect, p.x+((p.gaborDist)/sqrt(2)), p.y-((p.gaborDist)/sqrt(2))),generateTilt());
    Screen('DrawTexture',win,gaborTex,[],CenterRectOnPoint(p.gaborRect, p.x-((p.gaborDist)/sqrt(2)), p.y+((p.gaborDist)/sqrt(2))),tilt);
    Screen('DrawTexture',win,gaborTex,[],CenterRectOnPoint(p.gaborRect, p.x+((p.gaborDist)/sqrt(2)), p.y+((p.gaborDist)/sqrt(2))),generateTilt());
    Screen('Flip', win);
    WaitSecs(p.presentationTime);
    Screen('FillRect',win,p.CHcolor,fixation);
    Screen('Flip',win);
    WaitSecs(p.untilCueTime);
    Screen('FillRect',win,p.CHcolor,fixation);
    Screen('FrameOval',win,p.CHcolor, CenterRectOnPoint(p.gaborRect, p.x-((p.gaborDist)/sqrt(2)), p.y+((p.gaborDist)/sqrt(2))));
    Screen('Flip',win);
end
if f == 4
    Screen('FillRect',win,p.CHcolor,fixation);
    Screen('DrawTexture',win,gaborTex,[],CenterRectOnPoint(p.gaborRect, p.x-((p.gaborDist)/sqrt(2)), p.y-((p.gaborDist)/sqrt(2))),generateTilt());
    Screen('DrawTexture',win,gaborTex,[],CenterRectOnPoint(p.gaborRect, p.x+((p.gaborDist)/sqrt(2)), p.y-((p.gaborDist)/sqrt(2))),generateTilt());
    Screen('DrawTexture',win,gaborTex,[],CenterRectOnPoint(p.gaborRect, p.x-((p.gaborDist)/sqrt(2)), p.y+((p.gaborDist)/sqrt(2))),generateTilt());
    Screen('DrawTexture',win,gaborTex,[],CenterRectOnPoint(p.gaborRect, p.x+((p.gaborDist)/sqrt(2)), p.y+((p.gaborDist)/sqrt(2))),tilt);
    Screen('Flip', win);
    WaitSecs(p.presentationTime);
    Screen('FillRect',win,p.CHcolor,fixation);
    Screen('Flip',win);
    WaitSecs(p.untilCueTime);
    Screen('FillRect',win,p.CHcolor,fixation);
    Screen('FrameOval',win,p.CHcolor, CenterRectOnPoint(p.gaborRect, p.x+((p.gaborDist)/sqrt(2)), p.y+((p.gaborDist)/sqrt(2))));
    Screen('Flip',win);
end
if f == 5
    Screen('FillRect',win,p.CHcolor,fixation);
    Screen('DrawTexture',win,gaborTex,[],CenterRectOnPoint(p.gaborRect, p.x-p.gaborDist, p.y),tilt);
    Screen('DrawTexture',win,gaborTex,[],CenterRectOnPoint(p.gaborRect, p.x+p.gaborDist, p.y),generateTilt());
    Screen('DrawTexture',win,gaborTex,[],CenterRectOnPoint(p.gaborRect, p.x, p.y-p.gaborDist),generateTilt());
    Screen('DrawTexture',win,gaborTex,[],CenterRectOnPoint(p.gaborRect, p.x, p.y+p.gaborDist),generateTilt());
    Screen('Flip', win);
    WaitSecs(p.presentationTime);
    Screen('FillRect',win,p.CHcolor,fixation);
    Screen('Flip',win);
    WaitSecs(p.untilCueTime);
    Screen('FillRect',win,p.CHcolor,fixation);
    Screen('FrameOval',win,p.CHcolor, CenterRectOnPoint(p.gaborRect, p.x-p.gaborDist, p.y));
    Screen('Flip',win);
end
if f == 6
    Screen('FillRect',win,p.CHcolor,fixation);
    Screen('DrawTexture',win,gaborTex,[],CenterRectOnPoint(p.gaborRect, p.x-p.gaborDist, p.y),generateTilt());
    Screen('DrawTexture',win,gaborTex,[],CenterRectOnPoint(p.gaborRect, p.x+p.gaborDist, p.y),tilt);
    Screen('DrawTexture',win,gaborTex,[],CenterRectOnPoint(p.gaborRect, p.x, p.y-p.gaborDist),generateTilt());
    Screen('DrawTexture',win,gaborTex,[],CenterRectOnPoint(p.gaborRect, p.x, p.y+p.gaborDist),generateTilt());
    Screen('Flip', win);
    WaitSecs(p.presentationTime);
    Screen('FillRect',win,p.CHcolor,fixation);
    Screen('Flip',win);
    WaitSecs(p.untilCueTime);
    Screen('FillRect',win,p.CHcolor,fixation);
    Screen('FrameOval',win,p.CHcolor, CenterRectOnPoint(p.gaborRect, p.x+p.gaborDist, p.y));
    Screen('Flip',win);
end
if f == 7
    Screen('FillRect',win,p.CHcolor,fixation);
    Screen('DrawTexture',win,gaborTex,[],CenterRectOnPoint(p.gaborRect, p.x-p.gaborDist, p.y),generateTilt());
    Screen('DrawTexture',win,gaborTex,[],CenterRectOnPoint(p.gaborRect, p.x+p.gaborDist, p.y),generateTilt());
    Screen('DrawTexture',win,gaborTex,[],CenterRectOnPoint(p.gaborRect, p.x, p.y-p.gaborDist),tilt);
    Screen('DrawTexture',win,gaborTex,[],CenterRectOnPoint(p.gaborRect, p.x, p.y+p.gaborDist),generateTilt());
    Screen('Flip', win);
    WaitSecs(p.presentationTime);
    Screen('FillRect',win,p.CHcolor,fixation);
    Screen('Flip',win);
    WaitSecs(p.untilCueTime);
    Screen('FillRect',win,p.CHcolor,fixation);
    Screen('FrameOval',win,p.CHcolor, CenterRectOnPoint(p.gaborRect, p.x, p.y-p.gaborDist));
    Screen('Flip',win);
end
if f == 8
    Screen('FillRect',win,p.CHcolor,fixation);
    Screen('DrawTexture',win,gaborTex,[],CenterRectOnPoint(p.gaborRect, p.x-p.gaborDist, p.y),generateTilt());
    Screen('DrawTexture',win,gaborTex,[],CenterRectOnPoint(p.gaborRect, p.x+p.gaborDist, p.y),generateTilt());
    Screen('DrawTexture',win,gaborTex,[],CenterRectOnPoint(p.gaborRect, p.x, p.y-p.gaborDist),generateTilt());
    Screen('DrawTexture',win,gaborTex,[],CenterRectOnPoint(p.gaborRect, p.x, p.y+p.gaborDist),tilt);
    Screen('Flip', win);
    WaitSecs(p.presentationTime);
    Screen('FillRect',win,p.CHcolor,fixation);
    Screen('Flip',win);
    WaitSecs(p.untilCueTime);
    Screen('FillRect',win,p.CHcolor,fixation);
    Screen('FrameOval',win,p.CHcolor, CenterRectOnPoint(p.gaborRect, p.x, p.y+p.gaborDist));
    Screen('Flip',win);
end

Screen('FillRect',win,p.CHcolor,fixation);
WaitSecs(p.postCueTime);
Screen('Flip',win);

