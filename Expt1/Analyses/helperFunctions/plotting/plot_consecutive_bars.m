function plot_consecutive_bars(data, xlabel_string, ylabel_string, plot_ind_data)

number_subjects = size(data,1);

figure
bar(1, mean(data(:,1),1), 'w');
hold
for i=2:size(data,2)
    bar(i, mean(data(:,i),1), 'w');
end


%Plot confidence intervals
for i=1:size(data,2)
    plot([i,i], [mean(data(:,i))-std(data(:,i))/sqrt(number_subjects), ...
        mean(data(:,i))+std(data(:,i))/sqrt(number_subjects)], 'k', 'LineWidth',2);
%     plot([i-.05,i+.05], [mean(data(:,i))-std(data(:,i))/sqrt(number_subjects), ...
%         mean(data(:,i))-std(data(:,i))/sqrt(number_subjects)], 'k');
%     plot([i-.05,i+.05], [mean(data(:,i))+std(data(:,i))/sqrt(number_subjects), ...
%         mean(data(:,i))+std(data(:,i))/sqrt(number_subjects)], 'k');
    if plot_ind_data
        plot(i, data(:,i), 'kx')
    end
end

xlabel(xlabel_string, 'FontSize',30)
ylabel(ylabel_string, 'FontSize',30);
xlim([.5, .5 + size(data,2)]);