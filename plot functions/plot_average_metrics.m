function plot_average_metrics(output, subs, sublabels, color, pos)
if ~exist('pos', 'var')
    pos = 1;
end

    mod(1) = "behavior";
    mod(2) = "behavior";
    subset{1} = logical(output.behavior.(subs(1)));
    subset{2} = logical(output.behavior.(subs(2)));
    my_xtick = {sublabels(1),sublabels(2)};
    test_label = "5/40 vs 10/40 ";


parameters = ["pwin", "pbetter","pstay", "winstay", "loseswitch", "matching_measure", "RI", "RI_B", "RI_W"];
parameterLabels = ["prob. win", "prob. choose better", "prob. stay", "win-stay", "lose-switch", "dev. from matching", "RI", "RI_B", "RI_W"];
ylims = {[20 80], [40, 90], [50, 100], [50, 100], [0, 50], [-.2, -.05], [0 .2], [0, .2], [0, .2]};
f = figure;
if pos
set(f, 'Position', [f.Position(1),f.Position(2),1233.714285714286,1.6*815.4285714285712]);
else
set(f, 'Position', [835,395.6666666666666,863.3333333333333,1304.666666666667]);
end
for i=1:9
    dataTemp = {output.(mod(1)).(parameters(i))(subset{1}); output.(mod(2)).(parameters(i))(subset{2})};
    dataN = 2;
    tempMean = [];
    tempSEM = [];
    
    for cntDD = 1:dataN
        tempMean(cntDD) = nanmean(dataTemp{cntDD});
        tempSEM(cntDD) = nansem(dataTemp{cntDD});
    end
    
    [hh pp ci stats] = ttest2((dataTemp{1}),(dataTemp{2}));
    [dd] = computeCohen_d((dataTemp{1}),(dataTemp{2}));
    d1 = my_cohensD(dataTemp{1}, dataTemp{2});
    my_text = strcat("p=",num2str(pp),"      d=",num2str(d1));
    disp(strcat(test_label,parameterLabels(i),": (t(",num2str(stats.df),")=",num2str(stats.tstat),", p=",num2str(pp),". d=",num2str(d1)));
    
    subplot(3,3,i);
    
    hold on
    multby = 100;
    if i>=6
        multby = 1;
    end
    hb = bar(tempMean(1)*multby,'FaceColor',color(1),'EdgeColor',color(1));
    hold on
    hbr = bar(2,tempMean(2)*multby, 'FaceColor',color(2),'EdgeColor',color(2));
    errorbar([1:2], tempMean*multby, tempSEM*multby,'.','MarkerSize',1,'lineWidth',1.5,'color','k');
    xlim([.5 2.5]);

    set(gca,'FontName','Helvetica','FontSize',15,'FontWeight','normal',...
        'LineWidth',3, 'YTick', ylims{i}(1):(ylims{i}(2)-ylims{i}(1))/2:ylims{i}(2), 'XTick', 1:1:2, 'XTickLabels', my_xtick);
    set(gca, 'tickdir', 'out');
    ylim(ylims{i});
    %text(.75, ylims{i}(2)*.95, my_text);
    if i~=6
        yrange = ylims{i}(2)-ylims{i}(1);
        mysigstar22([1 2],max([tempMean(1)*multby,tempMean(2)*multby])+.08*yrange,pp,gca,1.5,'down');
        h = line(1.5, nan, 'Color', 'none');
        h = legend(h, render_p_and_d_value(pp,d1), 'Location', 'northoutside', 'Interpreter', 'latex', 'FontSize', 10, 'FontName', 'Helvetica');
        if pp>.01
            
            h.Position = [h.Position(1)-.01, h.Position(2)+.025, h.Position(3), h.Position(4)];
        else
            h.Position = [h.Position(1)-.015, h.Position(2)+.025, h.Position(3), h.Position(4)];
        end
        legend box off;
    else
        set(gca,'XAxisLocation','top','YAxisLocation','left');
        yrange = ylims{i}(2)-ylims{i}(1);
        mysigstar22([1 2],min([tempMean(1),tempMean(2)])-.08*yrange,pp,gca,1.5,'up');
        h = line(1.5, nan, 'Color', 'none');
        h = legend(h, render_p_and_d_value(pp,d1), 'Location', 'southoutside', 'Interpreter', 'latex', 'FontSize', 10, 'FontName', 'Helvetica');
        if pp>.01
            
            h.Position = [h.Position(1)-.01, h.Position(2)-.02, h.Position(3), h.Position(4)];
        else
            h.Position = [h.Position(1)-.01, h.Position(2)-.02, h.Position(3), h.Position(4)];
        end
        legend box off;
    end
    %xlabel([sublabels(1), sublabels(2)]);
    ylabel(parameterLabels(i));
    %set(gcf,'units','centimeters')
    %set(gcf,'units','centimeters', 'position',[30,10,35,15]);
end


parameters = ["ERDS", "ERDS_win", "ERDS_lose"; "EODS", "EODS_better", "EODS_worse"; "ERODS", "ERODS_winbetter", "ERODS_winworse"; "BLANK", "ERODS_losebetter", "ERODS_loseworse"];
parameterLabels = ["ERDS", "ERDS_+", "ERDS_-"; "EODS", "EODS_B", "EODS_W"; 'ERODS', "ERODS_{B+}", "ERODS_{W+}"; 'BLANK', "ERODS_{B-}", "ERODS_{W-}"];

%ylims = {[.6, .8], [.1, .3], [.4, .6], [.6, .8], [.3, .5], [.1, .3], [.5, .8], [.3, .5], [.1, .3]};
figure('Position', [-45.857142857142854,400.7142857142857,1233.714285714286,1.6*815.4285714285712*4/3]);
for jj= 1:size(parameters,1)
    for kk=1:size(parameters,2)
        i = kk + (jj-1)*3;
        if ~(jj==4 && kk == 1)
            dataTemp = {output.(mod(1)).(parameters(jj,kk))(subset{1}); output.(mod(2)).(parameters(jj,kk))(subset{2})};
            dataN = 2;
            tempMean = [];
            tempSEM = [];
            for cntDD = 1:dataN
                tempMean(cntDD) = nanmean(dataTemp{cntDD});
                tempSEM(cntDD) = nansem(dataTemp{cntDD});
            end
            
            [hh pp ci stats] = ttest2((dataTemp{1}),(dataTemp{2}));
            [dd] = computeCohen_d((dataTemp{1}),(dataTemp{2}));
            d1 = my_cohensD(dataTemp{1}, dataTemp{2});
            my_text = strcat("p=",num2str(pp),"      d=",num2str(d1));
            disp(strcat(test_label,parameterLabels(jj,kk),": (t(",num2str(stats.df),")=",num2str(stats.tstat),", p=",num2str(pp),". d=",num2str(d1)));
            
            f = subplot(4,3,i);
            hold on
            multby = 1;
            hb = bar(tempMean(1)*multby,'FaceColor',color(1),'EdgeColor',color(1));
            hold on
            hbr = bar(2,tempMean(2)*multby, 'FaceColor',color(2),'EdgeColor',color(2));
            errorbar([1:2], tempMean*multby, tempSEM*multby,'.','MarkerSize',1,'lineWidth',1.5,'color','k');
            xlim([.5 2.5]);
            %text(.75, .75*.95, my_text);
            set(gca,'FontName','Helvetica','FontSize',15,'FontWeight','normal',...
                'LineWidth',3, 'YTick', 0:(.9)/2:.9, 'XTick', 1:1:2, 'XTickLabels', my_xtick);
            set(gca, 'tickdir', 'out');
            ylim([0 .9]);
            ylabel(parameterLabels(jj,kk));
                yrange = .9;
            h = line(1.5, nan, 'Color', 'none');
            mysigstar22([1 2],max([tempMean(1),tempMean(2)])+.08*yrange,pp,gca,1.5,'down');

            h = legend(h, render_p_and_d_value(pp,d1), 'Location', 'northoutside', 'Interpreter', 'latex', 'FontSize', 10, 'FontName', 'Helvetica');
            if pp>.01
                h.Position = [h.Position(1)-.015, h.Position(2)-.001, h.Position(3), h.Position(4)];
            else
                h.Position = [h.Position(1)-.015, h.Position(2)-.001, h.Position(3), h.Position(4)];
            end
            legend box off;
        end
    end
end
%fff = gcf;
%mysub = fff.Children(5);
%mysub.Position = mysub.Position - [0 0.12 0 0];
end