function plot_combined_metric_surfaces(output1,output2,point_col1,point_col2)
hold off;
 h = heatmap([1,2]);
 map = h.Colormap;
%map = colormap(bone(50));
close all;

labels = ["p(stay|win)", "p(win)", "ERDS+"; "p(switch|lose)", "p(lose)", "ERDS-";...
    "p(stay|better)", "p(better)", "EODS_B"; "p(switch|worse)", "p(worse)", "EODS_W";...
    "p(stay|win)", "p(switch|lose)", "ERDS"; "p(stay|better)", "p(switch|worse)", "EODS"];
bd_labels = ["winstay", "pwinR", "ERDS_win"; "loseswitch", "ploseR", "ERDS_lose";...
    "betterstay", "pbetterR", "EODS_better"; "worseswitch", "pworseR", "EODS_worse";...
    "winstay", "loseswitch", "ERDS"; "betterstay", "worseswitch", "EODS"];
figure; hold on;
for i=1:4
%%Surface plots 
    if i<3
        subplot(2,3,i+1);
    else
        subplot(2,3,i+2);
    end
    points = linspace(0,1,50);
    [win, WS] = meshgrid(points,points);
    ERDSp = (-win.*WS.*log2(WS)+-win.*(1-WS).*log2(1-WS));
    ERDSp(isnan(ERDSp)) = 0;
    s = surf(WS,win,ERDSp, 'FaceAlpha', 0.5);
    xlabel(labels(i,1));
    ylabel(labels(i,2));
    zlabel(labels(i,3));
        %colormap(brighten(map, -.7));
        colormap(map);
    s.EdgeAlpha = 0;
    %view(-129,10)
    
    hold on;    
    g = scatter3(output1.(bd_labels(i,1)),output1.(bd_labels(i,2)),output1.(bd_labels(i,3)),   'MarkerEdgeColor', point_col1);
    g.SizeData = 20;
    g = scatter3(output2.(bd_labels(i,1)),output2.(bd_labels(i,2)),output2.(bd_labels(i,3)),   'MarkerEdgeColor', point_col2);
    g.SizeData = 20;    
    set(gca, 'XTick', [0:.5:1], 'YTick', [0:.5:1], 'ZTick', [0:.5:1]);
    set(gca,'FontName','Helvetica','FontSize',16);
    set(gcf,'units','centimeters', 'position',[4.074583333333333,19.931944444444444,43.74444444444444,24.465138888888884]);
    %set(get(gca,'ylabel'),'rotation',-32);
    %set(get(gca,'xlabel'),'rotation',18);
    set(gca,'LineWidth',2)
    set(gca, 'tickdir', 'out')
    %axesLabelsAlign3D;
    yax = get(gca,'ylabel');
    xax = get(gca,'xlabel');
    
    set(yax, 'rotation', -31);
    set(xax, 'rotation', 17);
    
    xax.Position(2) = xax.Position(2) + .05;
    yax.Position(1) = yax.Position(1) + .04;
    
    yax.Position(2) = yax.Position(2);
    xax.Position(1) = xax.Position(1) -.1+.02-0.08;
end

for i=5:6
    if i==5
        subplot(2,3,1);
    else
        subplot(2,3,4);
    end
    points = linspace(0,1,50);
 [LS, WS] = meshgrid(points,points);
 lose = .5; %meshgrid(points);
 win = 1-lose;
 ERDS = -(WS.*win.*log2(WS)+(1-WS).*win.*log2(1-WS)...
    +LS.*lose.*log2(LS)+(1-LS).*lose.*log2(1-LS));
    s = surf(WS,LS,ERDS, 'FaceAlpha', 0.5);
    xlabel(labels(i,1));
    ylabel(labels(i,2));
    zlabel(labels(i,3));
        %colormap(brighten(map, -.7)); 
        colormap(map);
    s.EdgeAlpha = 0;
    %view(-129,10)
    hold on;
    g = scatter3(output1.(bd_labels(i,1)),output1.(bd_labels(i,2)),output1.(bd_labels(i,3)), 'MarkerEdgeColor', point_col1);
    g.SizeData = 20;
    g = scatter3(output2.(bd_labels(i,1)),output2.(bd_labels(i,2)),output2.(bd_labels(i,3)), 'MarkerEdgeColor', point_col2);
    g.SizeData = 20;    
    set(gca, 'XTick', [0:.5:1], 'YTick', [0:.5:1], 'ZTick', [0:.5:1]);
    set(gca,'FontName','Helvetica','FontSize',16);
    %set(get(gca,'ylabel'),'rotation',-32);
    %set(get(gca,'xlabel'),'rotation',18);
    set(gca,'LineWidth',2)
    set(gca, 'tickdir', 'out')
    
    yax = get(gca,'ylabel');
    xax = get(gca,'xlabel');
    
    set(yax, 'rotation', -31);
    set(xax, 'rotation', 17);
    
    xax.Position(2) = xax.Position(2) + .05;
    yax.Position(1) = yax.Position(1) + .04;
    
    yax.Position(2) = yax.Position(2) -.15+.02-0.07;
    xax.Position(1) = xax.Position(1) -.1+.02-0.08;
end
figure('Position', [161.6666666666667,958.3333333333333,1648.666666666667,678.6666666666667]); hold on;
for i=1:4
%%Surface plots 
    if i<3
        subplot(2,3,i+1);
    else
                subplot(2,3,i+2);
    end
    points = linspace(0,1,50);
    [win, WS] = meshgrid(points,points);
    ERDSp = (-win.*WS.*log2(WS)+-win.*(1-WS).*log2(1-WS));
    ERDSp(isnan(ERDSp)) = 0;
    s = surf(WS,win,ERDSp, 'FaceAlpha', 0.5);
        view(2);
        grid off;

    xlabel(labels(i,1));
    ylabel(labels(i,2));
    zlabel(labels(i,3));
        %colormap(brighten(map, -.7)); 
    colormap(map);
    b = colorbar('Ticks', [0, 0.5, .98], 'TickLabels', {'0', '0.5', '1'}, 'location', 'westoutside');
    b.Label.String = labels(i,3);
    b.Label.FontSize = 16;
    s.EdgeAlpha = 0;
    %view(-129,10)
    
    hold on;
    g = scatter3(output1.(bd_labels(i,1)),output1.(bd_labels(i,2)),ones(size(output1.(bd_labels(i,2)),1), size(output1.(bd_labels(i,2)),2)),'MarkerEdgeColor', point_col1);
    g.SizeData = 20;
    g = scatter3(output2.(bd_labels(i,1)),output2.(bd_labels(i,2)),ones(size(output2.(bd_labels(i,2)),1), size(output2.(bd_labels(i,2)),2)),'MarkerEdgeColor', point_col2);
    g.SizeData = 20;    
    set(gca, 'XTick', [0:.5:1], 'YTick', [0:.5:1], 'ZTick', [0:.5:1]);
    set(gca,'FontName','Helvetica','FontSize',16);
    %set(gcf,'units','centimeters', 'position',[10,10,60,35]);
    %set(get(gca,'ylabel'),'rotation',-32);
    %set(get(gca,'xlabel'),'rotation',18);
    set(gca,'LineWidth',2);
    set(gca, 'tickdir', 'out');
    %axesLabelsAlign3D;
    yax = get(gca,'ylabel');
    xax = get(gca,'xlabel');
    
%     set(yax, 'rotation', -32);
%     set(xax, 'rotation', 19);
%     
%     xax.Position(2) = xax.Position(2) + .05;
%     yax.Position(1) = yax.Position(1) + .07;
%     
%     yax.Position(2) = yax.Position(2) + .05;
%     xax.Position(1) = xax.Position(1) -.1;
end

for i=5:6
    if i==5
        subplot(2,3,1);
    else
        subplot(2,3,4);
    end
    points = linspace(0,1,50);
 [LS, WS] = meshgrid(points,points);
 lose = .5; %meshgrid(points);
 win = 1-lose;
 ERDS = -(WS.*win.*log2(WS)+(1-WS).*win.*log2(1-WS)...
    +LS.*lose.*log2(LS)+(1-LS).*lose.*log2(1-LS));
    s = surf(WS,LS,ERDS, 'FaceAlpha', 0.5);
        view(2);
        grid off;

    xlabel(labels(i,1));
    ylabel(labels(i,2));
    zlabel(labels(i,3));
    %    %colormap(brighten(map, -.7)); 
    colormap(map);
    b = colorbar('Ticks', [.2, 0.4, .6, .8, .99], 'TickLabels', {'0.2', '0.4', '0.6','0.8', '1'}, 'location', 'westoutside');
    b.Label.String = labels(i,3);
    b.Label.FontSize = 16;
    s.EdgeAlpha = 0;
    %view(-129,10)
    hold on;
    g = scatter3(output1.(bd_labels(i,1)),output1.(bd_labels(i,2)),ones(size(output1.(bd_labels(i,2)),1), size(output1.(bd_labels(i,2)),2)),  'MarkerEdgeColor', point_col1);
    g.SizeData = 20;
    g = scatter3(output2.(bd_labels(i,1)),output2.(bd_labels(i,2)),ones(size(output2.(bd_labels(i,2)),1), size(output2.(bd_labels(i,2)),2)),  'MarkerEdgeColor', point_col2);
    g.SizeData = 20;
    set(gca, 'XTick', [0:.5:1], 'YTick', [0:.5:1], 'ZTick', [0:.5:1]);
    set(gca,'FontName','Helvetica','FontSize',16);
    %set(gcf,'units','centimeters', 'position',[0,12,60,35]);
    %set(get(gca,'ylabel'),'rotation',-32);
    %set(get(gca,'xlabel'),'rotation',18);
    set(gca,'LineWidth',2)
    set(gca, 'tickdir', 'out')
    
%     yax = get(gca,'ylabel');
%     xax = get(gca,'xlabel');
%     
%     set(yax, 'rotation', -32);
%     set(xax, 'rotation', 19);
%     
%     xax.Position(2) = xax.Position(2) + .05;
%     yax.Position(1) = yax.Position(1) + .07;
%     
%     yax.Position(2) = yax.Position(2) -.15;
%     xax.Position(1) = xax.Position(1) -.1;
end
end