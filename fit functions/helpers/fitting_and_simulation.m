function models = fitting_and_simulation(all_stats, models, data_label, num_sim, only_fit)
disp("fitting & simulating:");
ses_num = length(all_stats);
%iterating over all models
stats_beh = cell(1,ses_num);
for sescnt = 1:ses_num
            stats = all_stats{sescnt};
            stats_beh{sescnt} = stats;
end
for k = 1:length(models)
    model = models{k};
    disp("fitting model: " + models{k}.label);
    tic
    if ~model.exists && ~models{k}.behav_flag
        ll = NaN(ses_num,1);
        bic = NaN(ses_num,1);
        nlike = NaN(ses_num,1);
        aic = NaN(ses_num,1);
        
        avg_ll = NaN(ses_num,1);
        stats_sim = cell(num_sim,ses_num);
        fitpar = cell(ses_num,1);
        lls = cell(ses_num,1);
        
        %fitting and simulating
        for sescnt = 1:ses_num
            stats = all_stats{sescnt};
            %fit model extracting best fit parameters, make sure it
            %actually fits
            end_sim = false;
            while ~end_sim
                end_sim = true;
                [fitpar{sescnt,1},ll(sescnt,1),bic(sescnt,1),nlike(sescnt,1),aic(sescnt,1)]=fit_fun(stats,model.fun,model.initpar,model.lb,model.ub);
                if (sum(fitpar{sescnt,1}-model.initpar)<.1)
                    end_sim = false;
                    model.initpar = .8*model.initpar+.2*model.initpar.*rand(1,length(model.initpar));
                end
            end
            
            %simulation
            player = struct;
            player.label = strcat('algo_',model.name);
            player.params = fitpar{sescnt,1};
            if strcmp(data_label, 'cohen')
                is_cohen = true;
            else
                is_cohen = false;
            end
            for j=1:num_sim
                if ~only_fit
                    if is_cohen
                        stats_sim{j,sescnt} = predictAgentSimulationBaited(player, stats);
                    else
                        stats_sim{j,sescnt} = predictAgentSimulationNotBaited(player, stats);
                    end 
                    stats_sim{j,sescnt}.hr_side = stats.hr_side;
                    stats_sim{j,sescnt}.block_indices = stats.block_indices;
                else 
                    stats_sim{j,sescnt} = stats;
                end
                
            end
        end
        models{k}.fitpar = fitpar;
        models{k}.stats_sim = stats_sim;
        models{k}.stats_beh = stats_beh;
        models{k}.ll = ll;
        models{k}.lls = lls;
        models{k}.aic = aic;
        models{k}.bic = bic;
        models{k}.nlike = nlike;
        models{k}.avg_ll= avg_ll;
    elseif models{k}.behav_flag
        models{k}.stats_sim = stats_beh;
    end
    toc
end
end