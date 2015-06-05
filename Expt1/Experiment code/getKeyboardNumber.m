function k = getKeyboardNumber()
% k = getKeyboardNumber()
%
% Get the keyboard number. For use with KbCheck on OSX.

d=PsychHID('Devices');
k = 0;

for n = 1:length(d)
    if strcmp(d(n).usageName,'Keyboard');
        k=n;
        break
    end
end