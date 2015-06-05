function conf = give_conf(signal, criteria)

%Initialize confidence at 1
conf = ones(length(signal),1);
criteria(end+1) = inf;

%Populate with the values 2:N
for i=1:length(criteria)-1
    conf(signal >= criteria(i) & signal < criteria(i+1)) = i + 1;
end