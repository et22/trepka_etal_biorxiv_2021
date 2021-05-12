function T = plot_metric_distributions_new_new(models, dataset_name)
filename = strcat('output/model/',dataset_name,'/behavior.mat');
load(filename, 'model_struct');
behav_struct = model_struct;
model_labels = {};
ks_stat_matching = {};
ks_stat_erodsw = {};
aic_mean = {};
aic_sem = {};
erodsw_mean = {};
erodsw_sem = {};
aics = [];
bics = [];

all_stats = behav_struct.model.stats_sim;
sim_idxes = [];
models_ptable = zeros(length(models)-1,6);
plabels = ["arew", "beta", "aunrew", "decay", "cweight","lweight"];
plabels_label = ["\alpha_{rew}", "\beta", "\alpha_{unrew}", "decay rate", "\omega_{choice}", "\omega_{reward}"];
pbounds = [0,1;0,100;0,1;0,1;-1,1;-1,1];
ses_lengths = nan(length(all_stats),1);
for sescnt = 1:length(all_stats)
    stats = all_stats{sescnt};
    ses_lengths(sescnt) = length(stats.c);
    num_blocks = length(stats.block_indices);
    for i=1:100
        sim_idxes(end+1:end+num_blocks) = i;
    end
end
for k=1:length(models)
    if ~models{k}.behav_flag
        filename = strcat('output/model/',dataset_name,'/',models{k}.name,'.mat');
        load(filename, 'model_struct');
        
        model_labels{k} = model_struct.model.label;
        
        % get aic 
        aic = model_struct.model.aic(:,1);
        aics = [aics, aic];
        aic_mean{k} = nanmean(aic);
        aic_sem{k} = nansem(aic);
        
        bic = model_struct.model.bic(:,1);
        bic_mean{k} = nanmean(bic);
        
        ll = model_struct.model.ll(:,1);
        ll_mean{k} = nanmean(ll);
        
        mcfadden_r_squared = 1-sum(ll)/(sum(ses_lengths.*(-log(.5))));
        mrs{k} = mcfadden_r_squared;
        % get erodsw
        erodsw = model_struct.ERODS_loseworse;
        erodsw_mean{k} = nanmean(erodsw);
        erodsw_sem{k} = nansem(erodsw);
        plabel = ["ERODS_{W-}", 'dev. from matching'];
        [~, ~, ks_stat_matching{k}] = kstest2(model_struct.matching_measure, behav_struct.matching_measure);
        [~, ~, ks_stat_erodsw{k}] = kstest2(model_struct.ERODS_loseworse, behav_struct.ERODS_loseworse);
            models{k}.erodsw_comp = nan(100,1);
            erodsw = model_struct.ERODS_loseworse;
            matchingg = model_struct.matching_measure;
            fparmat = cell2mat(model_struct.model.fitpar);
            for i=1:length(plabels)
                if any(strcmp(models{k}.plabels, plabels(i)))
                    models_ptable(k,i) = 1;
                    par_valu = find(strcmp(models{k}.plabels, plabels(i)));
                    [f, phi] = ksdensity(fparmat(:,par_valu),'Support', pbounds(i,:),'BoundaryCorrection','reflection');
                    models{k}.(plabels(i)).f = f;
                    models{k}.(plabels(i)).phi = phi; 
                    models{k}.(plabels(i)).x = fparmat(:,par_valu);
                end
            end
            for ii = 1:100
                curr_erodsw = erodsw(sim_idxes<=ii);
                curr_matching = matchingg(sim_idxes<=ii);
                [~, ~, models{k}.erodsw_comp(ii)] = kstest2(curr_erodsw, behav_struct.ERODS_loseworse);
                [~, ~, models{k}.matching_comp(ii)] = kstest2(curr_matching, behav_struct.matching_measure);
            end
     end
end
better_than_Dyn_RCM = [];
%output tabl
for k=1:length(models)-1
    [h, p] = ttest(aics(:,k),aics(:,end));
    better_than_Dyn_RCM(k) = p;
end
T = table(model_labels', aic_mean', aic_sem',better_than_Dyn_RCM',ll_mean',bic_mean',mrs', erodsw_mean', erodsw_sem',ks_stat_erodsw', ks_stat_matching', 'VariableNames', ["model", "aic", "aicsem", "ttest","ll","bic","mcfaddenr","ERODSw", "ERODSwsem", "DERODSw", "DMatching"]);
disp(T);

%convergence figure
figure;
hold on;
labels = [];
for k=[2,8]
    plot(models{k}.erodsw_comp, 'LineWidth', 2, 'Color', models{k}.color); % matching convergence
    labels = [labels; models{k}.label];
    set_axis_defaults();
end
ylabel("D_{ERODS_{W-}}");
xlabel("Number of simulations");
legend(labels, 'box', 'off');
yy = ylim;
ylim([yy(1)-.01; yy(2) + .01]);

figure;
hold on;
labels = [];
for k=[2,8]
    plot(models{k}.matching_comp, 'LineWidth', 2, 'Color', models{k}.color); % matching convergence
    labels = [labels; models{k}.label];
    set_axis_defaults();
end
yy = ylim;
ylim([yy(1)-.01; yy(2) + .01]);
ylabel("D_{dev. from match}");
xlabel("Number of simulations");
legend(labels, 'box', 'off');

%parameter distributions
figure('Position',[521,773,732,913]);
for p_idx = 1:length(plabels)
    subplot(3,2,p_idx);
    hold on;
    legend_label = [];
    for k = 1:length(models)-1
        if mod(k,2)==0
            if models_ptable(k,p_idx)==1
                legend_label = [legend_label; models{k}.label];
                plot(models{k}.(plabels(p_idx)).phi,models{k}.(plabels(p_idx)).f, 'LineWidth', 2, 'Color', models{k}.color); % matching convergence
                x = models{k}.(plabels(p_idx)).x;
                xline(nanmean(x),'--','Color',models{k}.color,'LineWidth',2,'HandleVisibility','off');
            end
        end
    end
    xlabel(plabels_label(p_idx));
    xlim(pbounds(p_idx,:));
    if mod(p_idx,2)==1
    end
    if p_idx>4
        xline(0, '--k', 'LineWidth', 2);
    end
    set_axis_defaults();
    if (p_idx == 1 || p_idx == 3 || p_idx == 5)
            ylabel("prob. density");
    end
    if (p_idx ==1 || p_idx == 5 || p_idx == 6)
        legend(legend_label, 'box', 'off');
    end
end