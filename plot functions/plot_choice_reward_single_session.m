function plot_choice_reward_single_session(stats, species_color,data_idx)
figure('Position',[0,0,1.3*1119.333333333333/2.5,560.6666666666666/2.4]); hold on;
if data_idx == 1
    avg = 10;
else
    avg = 10;
end
choice = movmean(stats.c,avg);
reward = movmean(stats.c.*stats.r, avg);
plot(choice, '-','Color', species_color, 'LineWidth', 2);
plot(reward,'--','Color','k','LineWidth', 2);
legend(["choice", "reward"], 'FontName', 'Helvetica', 'FontSize', 14, 'box', 'off', 'Position', [0,0,0.186139747995418,0.234375],'AutoUpdate', 'off');
for i = 2:length(stats.block_addresses)-1
    xline(stats.block_addresses(i), ':', 'Color', [.5 .5 .5],'LineWidth', 2);
end

set(gca, 'ylim', [-1 1], 'ytick', -1:.5:1, 'FontName', 'Helvetica', 'FontSize', 14, 'LineWidth', 2, 'tickdir', 'out');
xlabel("trials");
if data_idx ==1
    ylabel({'mean', '\Leftarrow left     right \Rightarrow'}, 'Interpreter', 'Tex');
else
    ylabel({'mean', '\Leftarrow circle   square \Rightarrow'}, 'Interpreter', 'Tex');
end

figure('Position',[0,0,1.3*1119.333333333333/2.5,560.6666666666666/2.4]); hold on;
if data_idx == 1
    avg = 20;
else
    avg = 10;
end
choice = movsum(stats.c==1,avg)./(movsum(stats.c==-1,avg)+movsum(stats.c==1,avg));
reward = movsum((stats.c==1).*stats.r, avg)./(movsum((stats.c==-1).*stats.r, avg)+movsum((stats.c==1).*stats.r, avg));
plot(choice, '-','Color', species_color, 'LineWidth', 2);
plot(reward,'--','Color','k','LineWidth', 2);
legend(["choice", "reward"], 'FontName', 'Helvetica', 'FontSize', 14, 'box', 'off', 'Position', [0,0,0.186139747995418,0.234375],'AutoUpdate', 'off');
for i = 2:length(stats.block_addresses)-1
    xline(stats.block_addresses(i), ':', 'Color', [.5 .5 .5],'LineWidth', 2);
end

set(gca, 'ylim', [0 1], 'ytick', 0:.25:1, 'FontName', 'Helvetica', 'FontSize', 14, 'LineWidth', 2, 'tickdir', 'out');
xlabel("trials");
if data_idx ==1
    ylabel({'fraction', '\Leftarrow left     right \Rightarrow'}, 'Interpreter', 'Tex');
else
    ylabel({'fraction', '\Leftarrow circle   square \Rightarrow'}, 'Interpreter', 'Tex');
end

end