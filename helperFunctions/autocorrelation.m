function r = autocorrelation(data)

% A simple function to compute autocorrelation. The input in supposed to be
% a matrix with each column being a separate block. The autocorrelation is
% computed without assuming a relationship between the last trial on one
% block and the first trial on the next block.

prev = [];
curr = [];
for block=1:length(data)
    prev = [prev; data{block}(1:end-1)'];
    curr = [curr; data{block}(2:end)'];
end

r = r2z(corr(prev, curr));