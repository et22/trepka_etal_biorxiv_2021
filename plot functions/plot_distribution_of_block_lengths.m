function plot_distribution_of_block_lengths(output, colors, data_idx)
figure('Position',[13.666666666666666,57.666666666666664,1.3*1119.333333333333/2.5,560.6666666666666/2.4]); hold on;
hold on;
if data_idx == 1
[N,EDGES] = histcounts(output.block_length,[0:20:200]);
else
    [N,EDGES] = histcounts(output.block_length,[30:2:50]);
end
xTickSet = {};

for cntE = 2:length(EDGES)
    xTickSet{end+1} = num2str(mean([EDGES(cntE), EDGES(cntE-1)]));
end
    
bar(N/sum(N)*100,'FaceColor',colors,'EdgeColor',colors);
set(gca,'FontName','Helvetica','FontSize',14,'FontWeight','normal','LineWidth',2,'yTick',0:30:60,'Xtick',1:10,'XTickLabel',xTickSet)
if data_idx ==1
ylim([0 60]);
else
    set(gca, 'yTick', 0:10:20);
    ylim([0 20]);
end
set(gca, 'tickdir', 'out')
xlabel('block length');
ylabel('percent of blocks');
end
