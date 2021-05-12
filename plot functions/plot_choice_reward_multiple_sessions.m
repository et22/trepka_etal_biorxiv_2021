function plot_choice_reward_multiple_sessions(all_stats, data_subset, data_subsets_colors,data_subsets_labels,data_idx)
figure('Position',[0,0,1.3*1119.333333333333/2.5,560.6666666666666/2.4]); hold on;
if data_idx == 1
    avg = [2,0];
else
    avg = [2,0];
end

for sub_idx = 1:2
    choicef_run = [];
rewardf_run = [];
umf_run = [];
for i=1:length(all_stats)
    stats = all_stats{i};
    if stats.(data_subset(sub_idx))(1) == 1
    for j=2:length(stats.block_addresses)-1
        if stats.hr_side(stats.block_addresses(j)-2)==1
            choice = movsum(stats.c==1,avg)./(movsum(stats.c==-1,avg)+movsum(stats.c==1,avg));
            reward = movsum((stats.c==1).*stats.r, avg)./(movsum((stats.c==-1).*stats.r, avg)+movsum((stats.c==1).*stats.r, avg));
        else
            choice = 1-movsum(stats.c==1,avg)./(movsum(stats.c==-1,avg)+movsum(stats.c==1,avg));
            reward = 1-movsum((stats.c==1).*stats.r, avg)./(movsum((stats.c==-1).*stats.r, avg)+movsum((stats.c==1).*stats.r, avg));
        end
        um = (choice-reward).*sign(reward-.5);
        if stats.block_addresses(j)>11&&stats.block_addresses(j)+10<length(choice)
            if data_idx == 1
                run_idxes = stats.block_addresses(j)-10:stats.block_addresses(j)+10;
            elseif data_idx == 2
                 run_idxes = stats.block_addresses(j)-11:stats.block_addresses(j)+9;
            end
        umf_run = [umf_run, um(run_idxes)];
        choicef_run = [choicef_run, choice(run_idxes)];
        rewardf_run = [rewardf_run, reward(run_idxes)];
        end
    end
    end
end

plot(nanmean(choicef_run,2), '-','Color', data_subsets_colors(sub_idx), 'LineWidth', 2,'DisplayName',data_subsets_labels(sub_idx)+ " choice");
plot(nanmean(rewardf_run,2),'--','Color',data_subsets_colors(sub_idx),'LineWidth', 2, 'DisplayName',data_subsets_labels(sub_idx)+ " reward");
yyaxis right
plot(movmean(nanmean(umf_run,2),3),'-.','Color',data_subsets_colors(sub_idx),'LineWidth', 2,'DisplayName',data_subsets_labels(sub_idx)+ " matching");
ylabel("matching measure");
yyaxis left
end    
%legend([data_subsets_labels(1) + " choice", data_subsets_labels(1) + " reward",...
%    data_subsets_labels(1) + " matching",...
%    data_subsets_labels(2) + " choice", data_subsets_labels(2) + " reward",...
%        data_subsets_labels(2) + " matching",], 'FontName', 'Helvetica', 'FontSize', 12, 'box', 'off', 'Position', [0.809268379364104,0.699986964854217,0.186139747995418,0.234375],'AutoUpdate', 'off');
legend('FontName', 'Helvetica', 'FontSize', 12, 'box', 'off', 'Position', [0,0,0.186139747995418,0.234375],'AutoUpdate', 'off');

xline(11, ':', 'Color', [.5 .5 .5],'LineWidth', 2);
set(gca, 'ylim', [0 1], 'ytick', 0:.25:1, 'FontName', 'Helvetica', 'FontSize', 14, 'LineWidth', 2, 'tickdir', 'out', 'XTick', [1:5:21],'XTickLabels', [-10:5:10], 'Xlim', [1, 21]);
xlabel("trials");
if data_idx ==1
    ylabel({'fraction', '\Leftarrow worse     better \Rightarrow'}, 'Interpreter', 'Tex');
else
    ylabel({'fraction', '\Leftarrow worse   better \Rightarrow'}, 'Interpreter', 'Tex');
end

%% added for costa data
% figure
% plot(nanmean(umf_run1,2),'--','Color',data_subsets_colors(1),'LineWidth', 2);
% hold on;
% plot(nanmean(umf_run2,2),'--','Color',data_subsets_colors(2),'LineWidth', 2);
% set(gca, 'FontName', 'Helvetica', 'FontSize', 14, 'LineWidth', 2, 'tickdir', 'out', 'XTick', [1:5:21],'XTickLabels', [-10:5:10], 'Xlim', [1, 21]);
% xlabel("trials");
% ylabel("matching");
% legend([data_subsets_labels(1) + " matching",...
%     data_subsets_labels(2) + " matching"], 'FontName', 'Helvetica', 'FontSize', 12, 'box', 'off', 'Position', [0.809268379364104,0.699986964854217,0.186139747995418,0.234375],'AutoUpdate', 'off');
% xline(11, ':', 'Color', [.5 .5 .5],'LineWidth', 2);


end