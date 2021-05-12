function output = longest_measurable_integration_timescale(animal_stats, avg_window, gamma)
% see Iigaya et. al 2019, approach is similar, but we use blocks instead of
% sessions

choice = [];
reward = [];
choice_fraction = [];
reward_fraction = [];
block_nums = [];
lags = 0:-1:-5;
for block_num = 1:length(animal_stats)
    stats = animal_stats{block_num};
    choice = [choice; stats.c];
    reward = [reward; stats.r];
    choice_fraction = [choice_fraction; mean( stats.c== -1)/(mean(stats.c==-1)+mean(stats.c==1))];
    reward_fraction = [reward_fraction; (mean(stats.r==1&stats.c==-1))/...
        (mean(stats.r==1&stats.c==-1) + mean(stats.r==1&stats.c==1))];    
    block_nums = [block_nums; ones(length(stats.c),1)*block_num];
end

for block_num = 1:length(animal_stats)
    if (block_num>avg_window+5)
        block_idx = (block_nums<= block_num && block_nums>block_num-avg_window);
        matching_line = fitlm(reward_fraction(block_idx), choice_fraction(block_idx));
        option_choice_bias = lm.Coefficients.Estimate(2)*.5 + lm.Coefficients.Estimate(1);
        for lag_num = 1:length(lags)
            lag_idx = (block_nums<= block_num-lags(lag_num) && block_nums>block_num-lags(lag_num)-avg_window);
            rew_choice = reward(lag_idx).*choice(lag_idx);
            reward_option_imbalance = (rew_choice==-1 - rew_choice==1)/length(rew_choice);
            %% AHHHHHHH!!!!!!!!!!!!!!!!!!!!!!!!
        end
    else
        lmit(block_num) = NaN;
    end
    stats = animal_stats{block_num};
    choice = [choice; stats.c];
    reward = [reward; stats.r];
    block_nums = [block_nums; ones(length(stats.c),1)*block_num];
end


for 
end