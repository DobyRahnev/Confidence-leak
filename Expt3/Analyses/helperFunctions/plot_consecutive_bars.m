function plot_consecutive_bars(data, ylabel_string)

number_subjects = size(data,1);

figure
%ax = axes;
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
end

legend('High attention (2 patches)', 'Low attention (4 patches)');
%xlabel('Confidence on task 1', 'FontSize',30)
ylabel(ylabel_string, 'FontSize',30);
xlim([.5, 2.5]);
% ylim([0, 6]);
% set(ax,'XTick',[1:size(data,2)]);
% set(ax,'YTick',[0 .5 1]);
%legend('2 patches', '4 patches');