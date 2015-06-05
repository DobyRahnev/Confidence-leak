function startData = startExperiment(experimentName)

disp('working from directory')
disp([pwd ' ...'])
disp(' ')

dataDir = [pwd '/data/'];
d = dir(dataDir);
[filenames{1:length(d)}] = deal(d.name);

subNum = 1;
currentFile = [experimentName '_S' num2str(subNum) '.mat'];
while any(strcmp(filenames,currentFile))
    subNum = subNum + 1;
    currentFile = [experimentName '_S' num2str(subNum) '.mat'];
end

suggestedSubNum = subNum;
disp(['Suggested subject number is ' num2str(suggestedSubNum)])
ok = input('Is this OK?  (y=1, n=0)   ');

if ~ok
    disp('')
    subNum = -1;
    while subNum < suggestedSubNum
        subNum = input(['Enter subject number (must be greater than ' num2str(suggestedSubNum-1) ') : ']);
    end
end

currentFile = [experimentName '_S' num2str(subNum) '.mat'];
dataFile = [dataDir currentFile];

% get distance from screen
%distFromScreen_inCm = input('Enter distance from screen in cm:   ');

% general comments
comments = input('Comments?   ','s');

startData.subNum              = subNum;
startData.dataDir             = dataDir;
startData.dataFile            = dataFile;
%startData.distFromScreen_inCm = distFromScreen_inCm;
startData.comments            = comments;