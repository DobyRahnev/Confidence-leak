function BayesFactor = bayes_factor(data, uniform, distribParams)

%=========================================================================
% This function computes Bayes factors based on Dienes (2008). The function
% is a slightly modified version of the code in http://www.lifesci.sussex.ac.uk/home/Zoltan_Dienes/inference/Bayesfactor.html
% An online calculator for the same is avaiable here: http://www.lifesci.sussex.ac.uk/home/Zoltan_Dienes/inference/bayes_factor.swf
% 
% Parameters:
% data:             A vector of values for 1-tailed t-test
% uniform:          Is the distribution of p(population value|theory) uniform? 1= yes 0=no 
% distribParams:    A structure with the parameters of the distribution
% if uniform == 1, distribParams should have subfields lower and upper
% corresponding to the limits of the uniform distribution
% if uniform == 0, distribParams should have subfields mean, SD, and tail
% corresponding to the parameters of the alternative hypothesis.
%=========================================================================

normaly = @(mn, variance, x) 2.718283^(- (x - mn)*(x - mn)/(2*variance))/realsqrt(2*pi*variance);

%% Compute parameters
obtained = mean(data);
SE = std(data)/sqrt(length(data));
if length(data) < 30 %correction for small data samples
    df = length(data) - 1;
    SE = SE * (1 + 20/(df*df));
end
sd2 = SE^2;

%% Determine the assumed alternative hypothesis
if uniform == 0
    meanoftheory = distribParams.mean; %'What is the mean of p(population value|theory)?
    sdtheory = distribParams.SD; %'What is the standard deviation of p(population value|theory)?
    omega = sdtheory*sdtheory;
    tail = distribParams.tail; %'Is the distribution one-tailed or two-tailed? (1/2)
elseif uniform == 1
    lower = distribParams.lower; %'What is the lower bound? '
    upper = distribParams.upper; %'What is the upper bound? '
else
    error('Incorrect value of uniform. Please, use 0 or 1.')
end


%% Perform computations
area = 0;
if uniform == 1
    theta = lower;
else theta = meanoftheory - 5*(omega)^0.5;
end
if uniform == 1
    incr = (upper- lower)/2000;
else incr =  (omega)^0.5/200;
end

for A = -1000:1000
    theta = theta + incr;
    if uniform == 1
        dist_theta = 0;
        if and(theta >= lower, theta <= upper)
            dist_theta = 1/(upper-lower);
        end
    else %distribution is normal
        if tail == 2
            dist_theta = normaly(meanoftheory, omega, theta);
        else
            dist_theta = 0;
            if theta > 0
                dist_theta = 2*normaly(meanoftheory, omega, theta);
            end
        end
    end
    
    height = dist_theta * normaly(theta, sd2, obtained); %p(population value=theta|theory)*p(data|theta)
    area = area + height*incr; %integrating the above over theta
end

Likelihoodtheory = area;
Likelihoodnull = normaly(0, sd2, obtained);
BayesFactor = Likelihoodtheory/Likelihoodnull;