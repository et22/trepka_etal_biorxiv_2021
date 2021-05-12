function plot_metric_distributions_new(output, models, model_colors, data_idx, only_fit, behavior_color)
if data_idx == 1
    plot_metric_distributions_new_one(output, models, model_colors, data_idx, only_fit, behavior_color)
    %plot_metric_distributions_new_one_addendum(output, models, model_colors, data_idx, only_fit, behavior_color)
else
    plot_metric_distributions_new_two(output, models, model_colors, data_idx, only_fit, behavior_color)
    %plot_metric_distributions_new_two_addendum(output, models, model_colors, data_idx, only_fit, behavior_color)
end
end
function     plot_metric_distributions_new_one(output, models, model_colors, data_idx, only_fit, behavior_color)

%% new figure 1 
if data_idx == 1
    %figure('Position', [389,755,831.3333333333333/1.5,956]);
else
    %figure('Position', [389,755,831.3333333333333/1.5,956]);
end
f = figure('Position',[389,755,831.3333333333333/1.5,200]);% subplot(3, 3,[(i-1)*3+1, (i-1)*3+3]);
hold on;
plot_lls(models, model_colors, 'bic', data_idx);
%%
% 
% <latex>
% _idx
% </latex>
% 
%plot_lls(models, model_colors, 'll');
%subplot(6, 2, [3,4]); hold on;
%plot_lls(models, model_colors, 'bic');

if ~only_fit
    plist = {'ERODS_loseworse', 'matching_measure'};
    plabel = ["ERODS_{W-}", 'dev. from matching'];
    for i=2:3
        figure('Position',[389,755,831.3333333333333/1.5,400]);% subplot(3, 3,[(i-1)*3+1, (i-1)*3+3]);
        hold on;
        o.X1 = output.behavior.(plist{i-1});
        colors = [behavior_color;model_colors(2,:);model_colors(end,:)]; %was [65 90 125]/256
        o.X2 = output.Income.(plist{i-1});
        o.X3 = output.(models{end-1}.name).(plist{i-1});
        my_legend = ["Obs.", "RL2", "Dyn. LCM"];
        for ii=1:3
            [f, x, flo, fup] = ecdf(o.(strcat("X", int2str(ii))));
            shadedErrorBar(x', f', [fup'-f'; f'-flo'], {'LineWidth', 1, 'Color', colors(ii,:)});
            %plot(x,f,'LineWidth',2,'Color', colors(ii,:));
        end
        if i-1==1
            xlim([0, .5]);
        else
            xlim([-.5,0.05]);
        end
        set(gca, 'tickdir', 'out', 'linewidth',2,'fontsize',14,'fontname','Helvetica');
        xlabel(plabel(i-1));
        ylabel(strcat("fraction of data"));
        if i==2
            legend(my_legend, 'box', 'off', 'location', 'northeast');
        end
%         subplot(3, 3,(i-1)*3+3);
        xlims = xlim;
        ylims = ylim;
        wid = xlims(2)-xlims(1);
        hei = ylims(2)-ylims(1);
        x1 = xlims(1);
        y1 = ylims(1);
        ax_pos = get(gca, 'Position');
        hold on;
        [~, ~, ks2statIncome] = kstest2(output.Income.(plist{i-1}), output.behavior.(plist{i-1}));
        [~, ~, ks2statMod4] = kstest2(output.(models{end-1}.name).(plist{i-1}), output.behavior.(plist{i-1}));
            dstat = round(ks2statIncome*1000)/1000;
            dstat2 = round(ks2statMod4*1000)/1000;
        text_string_inc = strcat("$\mathbf{D_{RL2} = ", sprintf('%.3f',dstat), "}$");
        text_string_mod = strcat("$", "\mathbf{D_{Dyn.} = ", sprintf('%.3f',dstat2), "}$");
        ax = gca;
        if i-1==1
            text(.03,.94, text_string_inc,'Interpreter', 'latex', 'FontSize', 11);
            text(.37, .54, text_string_mod,'Interpreter', 'latex', 'FontSize', 11);
            ax1 = axes('Position',[ax_pos(1) + ax_pos(3)*.07, ax_pos(2)+.5*ax_pos(4), ax_pos(3)/5, ax_pos(4)/2.5], 'units', 'normalized');
            plot_side_by_side_histograms(o.X1, o.X2, colors(1:2,:),[0, .6]);
            ax1 = axes('Position',[ax_pos(1) + ax_pos(3)*.75, ax_pos(2)+.1*ax_pos(4), ax_pos(3)/5, ax_pos(4)/2.5], 'units', 'normalized');
            plot_side_by_side_histograms(o.X1, o.X3, [colors(1,:); colors(3,:)],[0, .6]);
            my_pos = ax1.Position;
            
        else
                        text(-.45, .54, text_string_inc,'Interpreter', 'latex', 'FontSize', 11);
            text(-.09, .54, text_string_mod,'Interpreter', 'latex', 'FontSize', 11);

            ax1 = axes('Position',[ax_pos(1) + ax_pos(3)*.08, ax_pos(2)+.1*ax_pos(4), ax_pos(3)/5, ax_pos(4)/2.5],'units', 'normalized');
            plot_side_by_side_histograms(o.X1, o.X2, colors(1:2,:),[-.5, .05]);
            
            ax1 = axes('Position',[ax_pos(1) + ax_pos(3)*.75, ax_pos(2)+.1*ax_pos(4), ax_pos(3)/5, ax_pos(4)/2.5], 'units', 'normalized');
            plot_side_by_side_histograms(o.X1, o.X3, [colors(1,:); colors(3,:)],[-.5, .05]);

        end
        if i==2
            f = figure('Position',[937,1056,553,186]);% subplot(3, 3,[(i-1)*3+1, (i-1)*3+3]);
            plot_bar_plot(o.X1,o.X3,o.X2,[colors(1,:);colors(3,:);colors(2,:)],[my_legend(1), my_legend(3), my_legend(2)], [.2 .25]);
        end
    end
    
disp("KS test for UM Income vs Behave: k=" +ks2statIncome);
disp("KS test for UM " + models{end-1}.label + " vs Behave: k=" +ks2statMod4);
end

end
function     plot_metric_distributions_new_two(output, models, model_colors, data_idx, only_fit, behavior_color)

%% new figure 1 
if data_idx == 1
    %figure('Position', [389,755,831.3333333333333/1.5,956]);
else
    %figure('Position', [389,755,831.3333333333333/1.5,956]);
end
f = figure('Position',[389,755,831.3333333333333/1.5,200]);% subplot(3, 3,[(i-1)*3+1, (i-1)*3+3]);
hold on;
plot_lls(models, model_colors, 'bic', data_idx);
%%
% 
% <latex>
% _idx
% </latex>
% 
%plot_lls(models, model_colors, 'll');
%subplot(6, 2, [3,4]); hold on;
%plot_lls(models, model_colors, 'bic');

if ~only_fit
    plist = {'ERODS_loseworse', 'matching_measure'};
    plabel = ["ERODS_{W-}", 'dev. from matching'];
    for i=2:3
        figure('Position',[389,755,831.3333333333333/1.5,400]);% subplot(3, 3,[(i-1)*3+1, (i-1)*3+3]);
        hold on;
        o.X1 = output.behavior.(plist{i-1});
        colors = [behavior_color;model_colors(2,:);model_colors(end,:)]; %was [65 90 125]/256
        o.X2 = output.Income.(plist{i-1});
        o.X3 = output.(models{end-1}.name).(plist{i-1});
        my_legend = ["Obs.", "RL2", "Dyn. LCM"];
        for ii=1:3
            [f, x, flo, fup] = ecdf(o.(strcat("X", int2str(ii))));
            shadedErrorBar(x', f', [fup'-f'; f'-flo'], {'LineWidth', 1, 'Color', colors(ii,:)});
            %plot(x,f,'LineWidth',2,'Color', colors(ii,:));
        end
        if i-1==1
            xlim([0, .3]);
        else
            xlim([-.3,0.05]);
        end
        set(gca, 'tickdir', 'out', 'linewidth',2,'fontsize',14,'fontname','Helvetica');
        xlabel(plabel(i-1));
        ylabel(strcat("fraction of data"));
        if i==2
            legend(my_legend, 'box', 'off', 'location', 'north');
        end
%         subplot(3, 3,(i-1)*3+3);
        xlims = xlim;
        ylims = ylim;
        ax_pos = get(gca, 'Position');
        hold on;
        [~, ~, ks2statIncome] = kstest2(output.Income.(plist{i-1}), output.behavior.(plist{i-1}));
        [~, ~, ks2statMod4] = kstest2(output.(models{end-1}.name).(plist{i-1}), output.behavior.(plist{i-1}));
            dstat = round(ks2statIncome*1000)/1000;
            dstat2 = round(ks2statMod4*1000)/1000;
        text_string_inc = strcat("$\mathbf{D_{RL2} = ", sprintf('%.3f',dstat), "}$");
        text_string_mod = strcat("$", "\mathbf{D_{Dyn.} = ", sprintf('%.3f',dstat2), "}$");
        ax = gca;
        if i-1==1
            text(.02,.94, text_string_inc,'Interpreter', 'latex', 'FontSize', 11);
            text(.22, .54, text_string_mod,'Interpreter', 'latex', 'FontSize', 11);
            ax1 = axes('Position',[ax_pos(1) + ax_pos(3)*.07, ax_pos(2)+.5*ax_pos(4), ax_pos(3)/5, ax_pos(4)/2.5], 'units', 'normalized');
            plot_side_by_side_histograms(o.X1, o.X2, colors(1:2,:),[0, .4]);
            ax1 = axes('Position',[ax_pos(1) + ax_pos(3)*.75, ax_pos(2)+.1*ax_pos(4), ax_pos(3)/5, ax_pos(4)/2.5], 'units', 'normalized');
            plot_side_by_side_histograms(o.X1, o.X3, [colors(1,:); colors(3,:)],[0, .4]);
            my_pos = ax1.Position;
  
        else
            text(-.28, .59, text_string_inc,'Interpreter', 'latex', 'FontSize', 11);
            text(-.04, .59, text_string_mod,'Interpreter', 'latex', 'FontSize', 11);

            ax1 = axes('Position',[ax_pos(1) + ax_pos(3)*.08, ax_pos(2)+.15*ax_pos(4), ax_pos(3)/5, ax_pos(4)/2.5],'units', 'normalized');
            plot_side_by_side_histograms(o.X1, o.X2, colors(1:2,:),[-.3, .05]);
            
            ax1 = axes('Position',[ax_pos(1) + ax_pos(3)*.75, ax_pos(2)+.15*ax_pos(4), ax_pos(3)/5, ax_pos(4)/2.5], 'units', 'normalized');
            plot_side_by_side_histograms(o.X1, o.X3, [colors(1,:); colors(3,:)],[-.3, .05]);

        end
        if i==2
            f = figure('Position',[937,1056,553,186]);% subplot(3, 3,[(i-1)*3+1, (i-1)*3+3]);
            plot_bar_plot(o.X1,o.X3,o.X2,[colors(1,:);colors(3,:);colors(2,:)],[my_legend(1), my_legend(3), my_legend(2)], [.1 .15]);
        end
    end
    
disp("KS test for UM Income vs Behave: k=" +ks2statIncome);
disp("KS test for UM " + models{end-1}.label + " vs Behave: k=" +ks2statMod4);
end

end

function plot_lls(models, model_colors, field_name, data_idx)
%%
% 
% <latex>
% _
% </latex>
% 
for i=1:numel(models)
    if ~models{i}.behav_flag
    y(i) = nansum([models{i}.(field_name)], 'all');
    denom = length(models{i}.(field_name));
    y(i) = y(i)/denom;
    models{i}.(field_name)(1);
    x_label{i} = models{i}.label;
    end
end
for i=1:numel(models)-1
        barh(i, y(i), 'FaceColor', model_colors(i,:));
    hold on;
end

%     dataTemp = {x1,x2,x3};
%     dataN = 3;
%     tempMean = [];
%     tempSEM = [];
%     
%     for cntDD = 1:dataN
%         tempMean(cntDD) = nanmean(dataTemp{cntDD});
%         tempSEM(cntDD) = nansem(dataTemp{cntDD});
%     end
%     errorbar(tempMean,[1:3],  tempSEM,'.','horizontal','MarkerSize',1,'lineWidth',1,'color','k');


%barh(4, y(4), 'FaceColor', "#ff6700");
yticklabels(x_label);
set(gca,'FontName','Helvetica','FontSize',14,'FontWeight','normal','LineWidth',2, 'tickdir', 'out');
set(gca, 'tickdir', 'out', 'Ytick', 1:numel(models)-1);%numel(models));
ylim([0.4 numel(models)-1+.6]);
if data_idx == 1
xlim([min(y)-5, max(y)+5]);
else
    xlim([min(y)-1, max(y)+1]);
end
set(gca, 'box', 'off');
xlabel("BIC");
yticklabels(x_label);
%set(gca, 'PlotBoxAspectRatio', [3 1 1]);
end

function plot_bar_plot(x1, x2, x3, colors, y_label,xlims)
o.x1 = x1;
o.x2 = x2;
o.x3 = x3;
for i=1:3
    barh(i, nanmean(o.(strcat("x",int2str(i)))), 'FaceColor', colors(i,:));
    hold on;
end
    dataTemp = {x1,x2,x3};
    dataN = 3;
    tempMean = [];
    tempSEM = [];
    
    for cntDD = 1:dataN
        tempMean(cntDD) = nanmean(dataTemp{cntDD});
        tempSEM(cntDD) = nansem(dataTemp{cntDD});
    end
    errorbar(tempMean,[1:3],  tempSEM,'.','horizontal','MarkerSize',1,'lineWidth',1,'color','k');

%barh(4, y(4), 'FaceColor', "#ff6700");
yticklabels(y_label);
set(gca,'FontName','Helvetica','FontSize',14,'FontWeight','normal','LineWidth',2, 'tickdir', 'out');
set(gca, 'tickdir', 'out', 'Ytick', 1:3);%numel(models));
ylim([0.4 3+.6]);
xlim(xlims);
set(gca, 'box', 'off');
xlabel("ERODS_{W-}");
end
function plot_side_by_side_histograms(x1, x2, colors,my_ylim)
        hold on;
        % rather than a square plot, make it thinner
        n = numel(x2);
        %randomly select 10% of data bc its just for visualization
        %purposes, and 100% of the data takes way too long
        index= randperm(n, ceil(n * 0.01));
    violinPlot(x1, 'histOri', 'left', 'widthDiv', [2 1], 'showMM', 0, ...
        'color',  mat2cell(colors(1,:), 1));
    %yline(nanmean(x1),'--','color',  colors(1,:), 'LineWidth', 1.5);
    violinPlot(x2(index)', 'histOri', 'right', 'widthDiv', [2 2], 'showMM', 0, ...
        'color',  mat2cell(colors(2,:), 1));
    %    yline(nanmean(x2),'--','color',  colors(2,:), 'LineWidth', 1.5);

    set(gca, 'xtick', [], 'xticklabel', {}, 'xlim', [.5 1.5]);

    % add significance stars for each bar
    %xticks = get(gca, 'xtick');
    ylim(my_ylim);
    % significance star for the difference
    %[~, pval, ks2stat] = kstest2(x1,x2);
    % if mysigstar gets 2 xpos inputs, it will draw a line between them and the
    % sigstars on top
    ys = ylim;
    xs = xlim;
    
    %mysigstar(gca, xticks, ys(2)*.8, ks2stat);
    set(gca,'FontName','Helvetica','FontSize',10,'FontWeight','normal','LineWidth',2, 'tickdir', 'out');

end


function     plot_metric_distributions_new_one_addendum(output, models, model_colors, data_idx, only_fit, behavior_color)

%% new figure 1 
if data_idx == 1
    %figure('Position', [389,755,831.3333333333333/1.5,956]);
else
    %figure('Position', [389,755,831.3333333333333/1.5,956]);
end
%%
% 
% <latex>
% _idx
% </latex>
% 
%plot_lls(models, model_colors, 'll');
%subplot(6, 2, [3,4]); hold on;
%plot_lls(models, model_colors, 'bic', data_idx);

if ~only_fit
    plist = {'ERODS_loseworse', 'matching_measure'};
    plabel = ["ERODS_{W-}", 'dev. from matching'];
    for i=2:3
        figure('Position',[389,755,831.3333333333333/1.5,400]);% subplot(3, 3,[(i-1)*3+1, (i-1)*3+3]);
        hold on;
        o.X1 = output.behavior.(plist{i-1});
        colors = [behavior_color;model_colors(2,:);model_colors(1,:)]; %was [65 90 125]/256
        o.X2 = output.(models{5}.name).(plist{i-1});
        o.X3 = output.(models{6}.name).(plist{i-1});
        my_legend = ["Obs.", models{5}.label, models{6}.label];
        for ii=1:3
            [f, x, flo, fup] = ecdf(o.(strcat("X", int2str(ii))));
            shadedErrorBar(x', f', [fup'-f'; f'-flo'], 'lineProps',{'LineWidth', 1, 'Color', colors(ii,:)});
            %plot(x,f,'LineWidth',2,'Color', colors(ii,:));
        end
        if i-1==1
            xlim([0, .5]);
        else
            xlim([-.5,0.05]);
        end
        set(gca, 'tickdir', 'out', 'linewidth',2,'fontsize',14,'fontname','Helvetica');
        xlabel(plabel(i-1));
        ylabel(strcat("fraction of data"));
        if i==2
            legend(my_legend, 'box', 'off', 'location', 'northeast');
        end
%       subplot(3, 3,(i-1)*3+3);
        xlims = xlim;
        ylims = ylim;
        wid = xlims(2)-xlims(1);
        hei = ylims(2)-ylims(1);
        x1 = xlims(1);
        y1 = ylims(1);
        ax_pos = get(gca, 'Position');
        hold on;       
        [~, ~, ks2statIncome] = kstest2(o.X2, o.X1);
        [~, ~, ks2statMod4] = kstest2(o.X3, o.X1);
            dstat = round(ks2statIncome*1000)/1000;
            dstat2 = round(ks2statMod4*1000)/1000;
        text_string_inc = strcat("$\mathbf{D_{",models{5}.label,"} = ", sprintf('%.3f',dstat), "}$");
        text_string_mod = strcat("$", "\mathbf{D_{",models{6}.label,"}, = ", sprintf('%.3f',dstat2), "}$");
        ax = gca;
        if i-1==1
            text(.03,.94, text_string_inc,'Interpreter', 'latex', 'FontSize', 11);
            text(.37, .54, text_string_mod,'Interpreter', 'latex', 'FontSize', 11);
            ax1 = axes('Position',[ax_pos(1) + ax_pos(3)*.07, ax_pos(2)+.5*ax_pos(4), ax_pos(3)/5, ax_pos(4)/2.5], 'units', 'normalized');
            plot_side_by_side_histograms(o.X1, o.X2, colors(1:2,:),[0, .6]);
            ax1 = axes('Position',[ax_pos(1) + ax_pos(3)*.75, ax_pos(2)+.1*ax_pos(4), ax_pos(3)/5, ax_pos(4)/2.5], 'units', 'normalized');
            plot_side_by_side_histograms(o.X1, o.X3, [colors(1,:); colors(3,:)],[0, .6]);
            my_pos = ax1.Position;
            
        else
            text(-.45, .54, text_string_inc,'Interpreter', 'latex', 'FontSize', 11);
            text(-.09, .54, text_string_mod,'Interpreter', 'latex', 'FontSize', 11);

            ax1 = axes('Position',[ax_pos(1) + ax_pos(3)*.08, ax_pos(2)+.1*ax_pos(4), ax_pos(3)/5, ax_pos(4)/2.5],'units', 'normalized');
            plot_side_by_side_histograms(o.X1, o.X2, colors(1:2,:),[-.5, .05]);
            
            ax1 = axes('Position',[ax_pos(1) + ax_pos(3)*.75, ax_pos(2)+.1*ax_pos(4), ax_pos(3)/5, ax_pos(4)/2.5], 'units', 'normalized');
            plot_side_by_side_histograms(o.X1, o.X3, [colors(1,:); colors(3,:)],[-.5, .05]);

        end
        if i==2
            f = figure('Position',[937,1056,553,186]);% subplot(3, 3,[(i-1)*3+1, (i-1)*3+3]);
            plot_bar_plot(o.X1,o.X3,o.X2,[colors(1,:);colors(3,:);colors(2,:)],[my_legend(1), my_legend(3), my_legend(2)], [.2 .25]);
        end
    end
    
disp("KS test for UM  vs Behave: k=" +ks2statIncome);
disp("KS test for UM  vs Behave: k=" +ks2statMod4);
end

end
function     plot_metric_distributions_new_two_addendum(output, models, model_colors, data_idx, only_fit, behavior_color)

%% new figure 1 
if data_idx == 1
    %figure('Position', [389,755,831.3333333333333/1.5,956]);
else
    %figure('Position', [389,755,831.3333333333333/1.5,956]);
end
%%
% 
% <latex>
% _idx
% </latex>
% 
%plot_lls(models, model_colors, 'll');
%subplot(6, 2, [3,4]); hold on;
%plot_lls(models, model_colors, 'bic', data_idx);

if ~only_fit
    plist = {'ERODS_loseworse', 'matching_measure'};
    plabel = ["ERODS_{W-}", 'dev. from matching'];
    for i=2:3
        figure('Position',[389,755,831.3333333333333/1.5,400]);% subplot(3, 3,[(i-1)*3+1, (i-1)*3+3]);
        hold on;
        o.X1 = output.behavior.(plist{i-1});
        colors = [behavior_color;model_colors(2,:);model_colors(1,:)]; %was [65 90 125]/256
        o.X2 = output.(models{5}.name).(plist{i-1});
        o.X3 = output.(models{6}.name).(plist{i-1});
        my_legend = ["Obs.", models{5}.label, models{6}.label];
        for ii=1:3
            [f, x, flo, fup] = ecdf(o.(strcat("X", int2str(ii))));
            shadedErrorBar(x', f', [fup'-f'; f'-flo'], 'lineProps',{'LineWidth', 1, 'Color', colors(ii,:)});
            %plot(x,f,'LineWidth',2,'Color', colors(ii,:));
        end
        if i-1==1
            xlim([0, .3]);
        else
            xlim([-.3,0.05]);
        end
        set(gca, 'tickdir', 'out', 'linewidth',2,'fontsize',14,'fontname','Helvetica');
        xlabel(plabel(i-1));
        ylabel(strcat("fraction of data"));
        if i==2
            legend(my_legend, 'box', 'off', 'location', 'north');
        end
%         subplot(3, 3,(i-1)*3+3);
        xlims = xlim;
        ylims = ylim;
        ax_pos = get(gca, 'Position');
        hold on;
        [~, ~, ks2statIncome] = kstest2(o.X2, o.X1);
        [~, ~, ks2statMod4] = kstest2(o.X3, o.X1);
            dstat = round(ks2statIncome*1000)/1000;
            dstat2 = round(ks2statMod4*1000)/1000;
        text_string_inc = strcat("$\mathbf{D_{",models{5}.label,"} = ", sprintf('%.3f',dstat), "}$");
        text_string_mod = strcat("$", "\mathbf{D_{",models{6}.label,"} = ", sprintf('%.3f',dstat2), "}$");
        ax = gca;
        if i-1==1
            text(.02,.94, text_string_inc,'Interpreter', 'latex', 'FontSize', 11);
            text(.22, .54, text_string_mod,'Interpreter', 'latex', 'FontSize', 11);
            ax1 = axes('Position',[ax_pos(1) + ax_pos(3)*.07, ax_pos(2)+.5*ax_pos(4), ax_pos(3)/5, ax_pos(4)/2.5], 'units', 'normalized');
            plot_side_by_side_histograms(o.X1, o.X2, colors(1:2,:),[0, .4]);
            ax1 = axes('Position',[ax_pos(1) + ax_pos(3)*.75, ax_pos(2)+.1*ax_pos(4), ax_pos(3)/5, ax_pos(4)/2.5], 'units', 'normalized');
            plot_side_by_side_histograms(o.X1, o.X3, [colors(1,:); colors(3,:)],[0, .4]);
            my_pos = ax1.Position;
        else
            text(-.28, .59, text_string_inc,'Interpreter', 'latex', 'FontSize', 11);
            text(-.04, .59, text_string_mod,'Interpreter', 'latex', 'FontSize', 11);

            ax1 = axes('Position',[ax_pos(1) + ax_pos(3)*.08, ax_pos(2)+.15*ax_pos(4), ax_pos(3)/5, ax_pos(4)/2.5],'units', 'normalized');
            plot_side_by_side_histograms(o.X1, o.X2, colors(1:2,:),[-.3, .05]);
            
            ax1 = axes('Position',[ax_pos(1) + ax_pos(3)*.75, ax_pos(2)+.15*ax_pos(4), ax_pos(3)/5, ax_pos(4)/2.5], 'units', 'normalized');
            plot_side_by_side_histograms(o.X1, o.X3, [colors(1,:); colors(3,:)],[-.3, .05]);
        end
        if i==2
            f = figure('Position',[937,1056,553,186]);% subplot(3, 3,[(i-1)*3+1, (i-1)*3+3]);
            plot_bar_plot(o.X1,o.X3,o.X2,[colors(1,:);colors(3,:);colors(2,:)],[my_legend(1), my_legend(3), my_legend(2)], [.1 .15]);
        end
    end
    
disp("KS test for UM  vs Behave: k=" +ks2statIncome);
disp("KS test for UM  vs Behave: k=" +ks2statMod4);
end

end
