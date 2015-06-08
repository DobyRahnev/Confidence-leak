function r = autocorrelation(data)

prev = [];
curr = [];
for block=1:length(data)
    prev = [prev; data{block}(1:end-1)'];
    curr = [curr; data{block}(2:end)'];
end

r = r2z(corr(prev, curr));