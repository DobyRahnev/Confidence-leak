function plot_correlation(data1, data2, limit1, limit2)

B = regress(data2, [ones(length(data1),1), data1]);
y_value1 = B(1) + limit1(1)*B(2);
y_value2 = B(1) + limit1(2)*B(2);

figure
plot(data1, data2, '*')
hold
plot(limit1, [y_value1, y_value2], 'k-', 'LineWidth', 2)

xlim(limit1);
ylim(limit2);
xlabel('Confidence leak', 'FontSize',30)
ylabel('Metacognition (Type 2 AUC)', 'FontSize',30);
% set(ax,'XTick',[1:size(data,2)]);
% set(ax,'YTick',[0 .5 1]);