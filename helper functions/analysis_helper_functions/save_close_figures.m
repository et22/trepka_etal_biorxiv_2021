function save_close_figures(save_path) 
FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
for i=length(FigList):-1:1
    fig = FigList(i);
    set(fig, 'color', 'w');
    img = getframe(fig);
    if strcmp(fig.Name, '')
        imwrite(img.cdata, fullfile(strcat(save_path,num2str(i), '.png')));
    else
        imwrite(img.cdata, fullfile(strcat(save_path,'_',fig.Name, '.png')));
    end        
end
close all;
end