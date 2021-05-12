function all_stats_new = subset_sessions_rew_probs(all_stats, data_subsets)
all_stats_new = {};
trial_counter = 0;
block_counter = 0;
animal_ids = string;
cnt = 0;
for i=1:length(all_stats)
    stats = all_stats{i};
    if (sum(stats.(data_subsets(1))) + sum(stats.(data_subsets(2))))==length(stats.(data_subsets(1)))
        cnt = cnt+1;
        all_stats_new{end+1} = stats;
        trial_counter = trial_counter + length(stats.c);
        block_counter = block_counter + length(stats.(data_subsets(2)));
        animal_ids(cnt) = string(stats.animal_ids);
    end
end

animals = unique(animal_ids);
disp("Analyzing " + length(all_stats_new) + " sessions, " + block_counter +...
    " blocks, " + trial_counter + " trials from " + length(animals) + "animals.");
end
