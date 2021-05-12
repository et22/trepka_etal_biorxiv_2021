function plot_simulated_rl_model_matrices(output, rand_subsets)
for i=1:length(rand_subsets)
        name = rand_subsets(i);
        output.(name).a_rew = output.(name).a_rew';
        output.(name).a_unrew = output.(name).a_unrew';
        output.(name).sigma = output.(name).sigma';
        
        output.(name).sensitivity = 1./output.(name).sigma;
        output.(name).delta_alphas = output.(name).a_rew - output.(name).a_unrew;
        output.(name).delta_alphas_over_sigma = (output.(name).a_rew - output.(name).a_unrew)./output.(name).sigma;
        output.(name).sum_alphas = output.(name).a_rew + output.(name).a_unrew;
        
        corr_lbls = {'a_rew', 'a_unrew', 'sigma', 'sensitivity', 'sum_alphas', 'delta_alphas', 'delta_alphas_over_sigma', 'ERDS', 'ERDS_win', 'ERDS_lose','EODS','EODS_better','EODS_worse',...
            'ERODS', 'ERODS_winbetter', 'ERODS_losebetter', 'ERODS_winworse', 'ERODS_loseworse',...
            'matching_measure'};
        
        matrix_labels = {"\alpha(rew)", "\alpha(unrew)", "\sigma", "1/\sigma","\alpha(rew) + \alpha(unrew)",...
            "\alpha(rew)-\alpha(unrew)", "(\alpha(rew)-\alpha(unrew))/\sigma", "ERDS", "ERDS(win)", "ERDS(lose)", "EODS", "EODS(better)", "EODS(worse)","ERODS",...
            "ERODS(win,better)", "ERODS(lose,better)" , "ERODS(win,worse)", "ERODS(lose,worse)" ,"Dev. from matching"};
        
        returnRLMdl = fitlm([output.(name).a_rew, output.(name).a_unrew, output.(name).sigma], output.(name).matching_measure);
        entropyRLMdl = fitlm([output.(name).ERODS_loseworse, output.(name).ERODS_winworse, output.(name).ERODS_winbetter], output.(name).matching_measure);
        disp(strcat(rand_subsets(i), " ", "RL param model"));
        disp(returnRLMdl);
        disp(strcat(rand_subsets(i), " ", "entropy model"));
        disp(entropyRLMdl);
        
        finalCorrSt = [];
        for cntII = 1:length(corr_lbls)
            for cntJJ = 1:length(corr_lbls)
                lblTemp1 = corr_lbls{cntII};
                lblTemp2 = corr_lbls{cntJJ};
                
                tempData1 = output.(name).(lblTemp1);
                tempData2 = output.(name).(lblTemp2);
                
                sharedIdx = ~isnan(tempData1) & ~isnan(tempData2);
                
                [finalCorrSt.Pearson.R(cntII,cntJJ) , finalCorrSt.Pearson.P(cntII,cntJJ)] = ...
                    corr(tempData1(sharedIdx), tempData2(sharedIdx), 'type', 'Pearson');
                [finalCorrSt.Spearman.R(cntII,cntJJ) , finalCorrSt.Spearman.P(cntII,cntJJ)] = ...
                    corr(tempData1(sharedIdx), tempData2(sharedIdx) ,'type', 'Spearman');
                
            end
        end
                
        % plotting
        corr_type = ["Pearson", "Spearman"];
        corr_type_label = ["parametric", "non-parametric"];
        for j=1:2
            figure('Position', [507.8571428571428,676.4285714285714,995.857142857143,943.4285714285712]);
            %% Plot Correlation Matrix
            tmpMat = finalCorrSt.(corr_type(j)).R(:,:);
            tmpMat(finalCorrSt.(corr_type(j)).P(:,:)>0.0001) = nan;
            h = heatmap(matrix_labels, matrix_labels, round(tmpMat,2));
            set(gca,'FontName','Helvetica','FontSize',12,'CellLabelFormat','%0.2g',...
                'ColorLimits',[-1 1],'MissingDataLabel','n.s.');
            set(h.NodeChildren(3), 'XTickLabelRotation', 45, 'YTickLabelRotation', 45, 'FontSize',16);
            set(h.NodeChildren(2),  'FontSize',25);
            set(h.NodeChildren(1),  'FontSize',25);
            h.NodeChildren(3).Title.String = corr_type_label(j);
            h.NodeChildren(3).Title.FontSize = 25;
            h.NodeChildren(3).Title.FontWeight = 'normal';
            set(gcf,'color','w')
        end
        
%         corr_lbls = {'a_rew', 'a_unrew', 'sigma', 'sensitivity', 'sum_alphas', 'delta_alphas', 'delta_alphas_over_sigma',...
%             'MIRS', 'MIRS_win', 'MIRS_lose', 'MIOS', 'MIOS_better',...
%             'MIOS_worse', ...
%             'MIROS','MIROS_winbetter', 'MIROS_losssebetter', 'MIROS_winworse', 'MIROS_loseworse',...
%             'matching_measure'};
%         
%         matrix_labels = {"\alpha(rew)", "\alpha(unrew)", "\sigma", "1/\sigma","\alpha(rew) + \alpha(unrew)",...
%             "\alpha(rew)-\alpha(unrew)", "(\alpha(rew)-\alpha(unrew))/\sigma",...
%             "MIRS", "MIRS(win)", "MIRS(lose)", "MIOS", "MIOS(better)", "MIOS(worse)","MIROS",...
%             "MIROS(win,better)", "MIROS(lose,better)" , "MIROS(win,worse)", "MIROS(lose,worse)" ,"Dev. from matching"};
%        finalCorrSt = [];
%         for cntII = 1:length(corr_lbls)
%             for cntJJ = 1:length(corr_lbls)
%                 lblTemp1 = corr_lbls{cntII};
%                 lblTemp2 = corr_lbls{cntJJ};
%                 
%                 tempData1 = output.(name).(lblTemp1);
%                 tempData2 = output.(name).(lblTemp2);
%                 
%                 sharedIdx = ~isnan(tempData1) & ~isnan(tempData2);
%                 
%                 [finalCorrSt.Pearson.R(cntII,cntJJ) , finalCorrSt.Pearson.P(cntII,cntJJ)] = ...
%                     corr(tempData1(sharedIdx), tempData2(sharedIdx), 'type', 'Pearson');
%                 [finalCorrSt.Spearman.R(cntII,cntJJ) , finalCorrSt.Spearman.P(cntII,cntJJ)] = ...
%                     corr(tempData1(sharedIdx), tempData2(sharedIdx) ,'type', 'Spearman');
%                 
%             end
%         end
%                 
%         % plotting
%         corr_type = ["Pearson", "Spearman"];
%         corr_type_label = ["parametric", "non-parametric"];
%         for j=1:2
%             figure('Position', [507.8571428571428,676.4285714285714,995.857142857143,943.4285714285712]);
%             %% Plot Correlation Matrix
%             tmpMat = finalCorrSt.(corr_type(j)).R(:,:);
%             tmpMat(finalCorrSt.(corr_type(j)).P(:,:)>0.0001) = nan;
%             h = heatmap(matrix_labels, matrix_labels, round(tmpMat,2));
%             set(gca,'FontName','Helvetica','FontSize',12,'CellLabelFormat','%0.2g',...
%                 'ColorLimits',[-1 1],'MissingDataLabel','n.s.');
%             set(h.NodeChildren(3), 'XTickLabelRotation', 45, 'YTickLabelRotation', 45, 'FontSize',16);
%             set(h.NodeChildren(2),  'FontSize',25);
%             set(h.NodeChildren(1),  'FontSize',25);
%             h.NodeChildren(3).Title.String = corr_type_label(j);
%             h.NodeChildren(3).Title.FontSize = 25;
%             h.NodeChildren(3).Title.FontWeight = 'normal';
%             set(gcf,'color','w')
%         end
        

end
end