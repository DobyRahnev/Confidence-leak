function result = oneSample_tTest(variable, varargin)

%--------------------------------------------------------------------------
% A simple function for one sample t-test that organizes the results better
% than the default Matlab function. It also, optionally, reports the
% results if a second variable with the name of the analysis is provided.
%
% For paired t-tests, simply provide "variable1-variable2" as input.
%--------------------------------------------------------------------------

% Perform t-test and organize results in a single variable
[H P ci stats] = ttest(variable);
result.t = stats.tstat;
result.df = stats.df;
result.p = P;
result.CI = ci;

% Display results if analysis name is given
if ~isempty(varargin)
    fprintf(['Analysis (t-test) name: ' varargin{1} '\n']);
    fprintf(['t(' num2str(result.df) ') = ' num2str(result.t) ', p = ' num2str(result.p) '\n']);
end
    