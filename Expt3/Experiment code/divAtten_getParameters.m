function p = divAtten_getParameters()

if IsOSX
    p.keyboardNumber = getKeyboardNumber;
else
    p.keyboardNumber = [];
end

p.BGcolor = 127;
p.CHcolor = 0;
p.CHcolorTilt = [200 0 0];
p.CHcolorVis = [0 200 0];
p.CHsize = 10;
p.CHwidth = 2;

[midW midH] = getScreenMidpoint;
p.x = midW;
p.y = midH;

deg = 1.5;
dist = 60;
pix = degrees2pixels(deg, dist);
p.gaborRect = [0 0 pix pix];
p.gaborDist = degrees2pixels(4);

p.ansWait = 15;
p.nTrials = 125;
% p.nTrials = 10;

p.fixationTime = 0.5;
p.presentationTime = 0.03;
% p.presentationTime = 1;
p.untilCueTime = 0.5;
p.postCueTime = 0.1;


p.nStimTypes = 1;