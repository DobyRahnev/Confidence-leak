function plot_14ResponsePattern(data1, data2)

number_subjects = size(data1,1);

figure
ax = axes;
bar(1, mean(data1(:,1),1), 'w');
hold
bar(7, mean(data2(:,3),1), 'w');
for i=2:3
    bar(i, mean(data1(:,i),1), 'w');
    bar(i+3, mean(data2(:,i-1),1), 'w');
end


%Plot confidence intervals
for i=1:3
    plot([i,i], [mean(data1(:,i))-std(data1(:,i))/sqrt(number_subjects), ...
        mean(data1(:,i))+std(data1(:,i))/sqrt(number_subjects)], 'k');
%     plot([i-.05,i+.05], [mean(data1(:,i))-std(data1(:,i))/sqrt(number_subjects), ...
%         mean(data1(:,i))-std(data1(:,i))/sqrt(number_subjects)], 'k');
%     plot([i-.05,i+.05], [mean(data1(:,i))+std(data1(:,i))/sqrt(number_subjects), ...
%         mean(data1(:,i))+std(data1(:,i))/sqrt(number_subjects)], 'k');

    plot([i+4,i+4], [mean(data2(:,i))-std(data2(:,i))/sqrt(number_subjects), ...
        mean(data2(:,i))+std(data2(:,i))/sqrt(number_subjects)], 'k');
%     plot([j-.05,j+.05], [mean(data2(:,i))-std(data2(:,i))/sqrt(number_subjects), ...
%         mean(data2(:,i))-std(data2(:,i))/sqrt(number_subjects)], 'k');
%     plot([j-.05,j+.05], [mean(data2(:,i))+std(data2(:,i))/sqrt(number_subjects), ...
%         mean(data2(:,i))+std(data2(:,i))/sqrt(number_subjects)], 'k');
end

title('Confidence ratings pattern', 'FontSize', 30)
ylabel('Percent responses', 'FontSize', 20);
xlim([.5, 7.5]);
%ylim([0, 6]);
set(ax,'XTick',[1,2,3,5,6,7]);
% %set(ax,'YTick',[0 .5 1]);
legend('Confidence of 1', 'Confidence of 4')