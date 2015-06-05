function [midW midH] = getScreenMidpoint(window)
% [midW midH] = getScreenMidpoint(window)
%
% Returns the central width and height values of the current PTB window in
% pixels.

if ~exist('window','var')
    windowPtrs = Screen('Windows');
    rect = Screen('Rect',windowPtrs(1)); % assume all windows are same size
else
    rect = Screen('Rect',window);
end

W=rect(3);
H=rect(4);

midW = W/2;
midH = H/2;