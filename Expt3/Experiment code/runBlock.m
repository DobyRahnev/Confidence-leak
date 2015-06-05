function [data exitNow] = runBlock(nTrials,contrastArray,type,questing,feedback)

p = divAtten_getParameters;
nStimTypes = p.nStimTypes;
contrastVals = contrastArray; 
exptStim = [];     % holds code for stimulation type
exptContrast = []; % holds contrast values
i = 1;

while length(exptStim) < nTrials                       % while exptStim holds less than nTrials elements...
  for currentStimType = 1:nStimTypes                          % looping over values for stimType,
    for currentContrast = 1:length(contrastVals)                     % looping over values for contrast,
      exptStim = [exptStim currentStimType];                                     % tack on current stimType to exptStim
      exptContrast = [exptContrast contrastVals(currentContrast)];       % tack on current contrast to exptContrast
    end
  end
end

% now in exptStim and exptContrast we have counterbalanced data with respect to nTrials and with respect to eachother
% we just have to randomize the order

[exptStim shuffleOrder] = Shuffle(exptStim);    % randomize exptStim order; store order of shuffling in shuffleOrder
exptContrast = exptContrast(shuffleOrder);      % apply the exact same randomization to exptContrast, to preserve counterbalancing

data = [];

while i <= nTrials
    [isAccurate isVisible direction exitNow] = runTrial(type,exptContrast(i),questing,feedback);
    if exitNow == 1
        return;
    end
    data(i,1) = type;
    data(i,2) = exptContrast(i);
    data(i,3) = direction;
    data(i,4) = isAccurate;
    data(i,5) = isVisible;
    i=i+1;
end
