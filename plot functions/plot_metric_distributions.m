function plot_metric_distributions(output, models, model_colors)
%% new figure 1 
figure('Position', [389,755,596,956]);
subplot(4, 2, [1,2]); hold on;
plot_lls(models, model_colors);

plist = {'ERDS', 'winstay', 'loseswitch'};
plabel = ["ERDS", "win-stay", "lose-switch"];
for i=1:3
    for j=1:2
        subplot(4, 2, i*2+(j-1)+1);
        x1 = output.behavior.(plist{i});
        if j==1
            colors = [model_colors(5,:);model_colors(2,:)]; %was [65 90 125]/256
            x2 = output.Income.(plist{i});
            label = "RL2";
        elseif j==2
            colors = [model_colors(5,:);model_colors(4,:)];
            x2 = output.(models{4}.name).(plist{i});   
            label = models{4}.label;
        end
        plot_side_by_side_histograms(x1, x2, colors, label, plabel(i), [0,1.4]);
    end
end

plist = {'matching_measure'};
plabel = ["matching_measure"];
figure('Position', [389,755,1000,500]);
for i=1:1
    for j=1:2
        subplot(1, 2, j);
        x1 = output.behavior.(plist{i});
        if j==1
            colors = [model_colors(5,:);model_colors(2,:)]; %was [65 90 125]/256
            x2 = output.Income.(plist{i});
            label = "RL2";
        elseif j==2
            colors = [model_colors(5,:);model_colors(4,:)];
            x2 = output.(models{4}.name).(plist{i});   
            label = models{4}.label;
        end
        tempData1 = x1;
        tempData2 = x2;
        sharedIdx = ~isnan(x1)&~isnan(x2);
        [r , p] = ...
            corr(tempData1(sharedIdx), tempData2(sharedIdx), 'type', 'Pearson');
        scatter(x2, x1, .5, 'k');
        xlim([-.5 .25]);
        ylim([-.5 .25]);
        ylabel("Observed U.M.");
        xlabel(strcat("Predicted U.M., ", label));
        my_text = strcat("r=", num2str(r), "p=", num2str(p));
        text(-.4, .2, my_text);
        %plot_side_by_side_histograms(x1, x2, colors, label, plabel(i), [-.5,.25]);
    end
end



[~, ~, ks2statIncome] = kstest2(output.Income.matching_measure, output.behavior.matching_measure);
[~, ~, ks2statMod4] = kstest2(output.(models{4}.name).matching_measure, output.behavior.matching_measure);
disp("KS test for UM Income vs Behave: k=" +ks2statIncome);
disp("KS test for UM " + models{4}.label + " vs Behave: k=" +ks2statMod4);

end
function plot_side_by_side_histograms(x1, x2, colors, model_name, my_ylabel,my_ylim)
        hold on;
        % rather than a square plot, make it thinner
    violinPlot(x1, 'histOri', 'left', 'widthDiv', [2 1], 'showMM', 0, ...
        'color',  mat2cell(colors(1,:), 1));
    yline(nanmean(x1),'--','color',  colors(1,:), 'LineWidth', 1.5);
    violinPlot(x2, 'histOri', 'right', 'widthDiv', [2 2], 'showMM', 0, ...
        'color',  mat2cell(colors(2,:), 1));
        yline(nanmean(x2),'--','color',  colors(2,:), 'LineWidth', 1.5);

    set(gca, 'xtick', [0.6 1.4], 'xticklabel', {'Obs.', model_name}, 'xlim', [0.2 1.8]);
    ylabel(my_ylabel);

    % add significance stars for each bar
    xticks = get(gca, 'xtick');
    ylim(my_ylim);
    % significance star for the difference
    [~, pval, ks2stat] = kstest2(x1,x2);
    % if mysigstar gets 2 xpos inputs, it will draw a line between them and the
    % sigstars on top
    ys = ylim;
    mysigstar(gca, xticks, ys(2)*.8, ks2stat);
    set(gca,'FontName','Helvetica','FontSize',14,'FontWeight','normal','LineWidth',2, 'tickdir', 'out');

end
function plot_lls(models, model_colors)
for i=1:numel(models)
    if ~models{i}.behav_flag
    animals =models{i}.animal_ids;
    y(i) = 0;
    denom = 0;
    for j=1:length(animals)
        y(i) = nansum([y(i),models{i}.ll.(animals(j))], 'all');
        denom = denom + length(models{i}.ll.(animals(j)));
    end
    y(i) = y(i)/denom;
    x_label{i} = models{i}.label;
    end
end
for i=1:4
    barh(i, y(i), 'FaceColor', model_colors(i,:));
    hold on;
end

%barh(4, y(4), 'FaceColor', "#ff6700");
yticklabels(x_label);
set(gca,'FontName','Helvetica','FontSize',14,'FontWeight','normal','LineWidth',2, 'tickdir', 'out');
set(gca, 'tickdir', 'out', 'Ytick', 1:numel(models)-1);%numel(models));
ylim([0.4 numel(models)-1+.6]);
xlim([min(y)-5, max(y)+5]);
set(gca, 'box', 'off');
xlabel("-log likelihood");
yticklabels(x_label);
set(gca, 'PlotBoxAspectRatio', [3 1 1]);
end