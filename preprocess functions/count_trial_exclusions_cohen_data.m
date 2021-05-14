function count_trial_exclusions_cohen_data
    load('datasets\raw\behavstruct.mat', 'behavStruct');
    all_stats = preprocess_cohen_data(behavStruct);
    all_stats = subset_sessions_rew_probs(all_stats, ["prob1040","prob540"]);
    miss_trials = nan(length(all_stats), 1);
    nogo_trials = nan(length(all_stats), 1);
    included_trials = nan(length(all_stats), 1);
    for ses_num = 1:length(all_stats)
        miss_trials(ses_num) = all_stats{ses_num}.num_miss_trials;
        nogo_trials(ses_num) = all_stats{ses_num}.num_nogo_trials;
        included_trials(ses_num) = length(all_stats{ses_num}.c);
    end
    disp("cohen dataset trial exclusions:");
    disp("total number of included trials: " + nansum(included_trials));
    disp("total number of nogo trials excluded: " + nansum(nogo_trials));
    disp("total number of miss trials excluded: " + nansum(miss_trials));
    disp("average number of trials per session: " + nanmean(included_trials));
    disp("average number of nogo trials per session: " + nanmean(nogo_trials));
    disp("average number of miss trials per session: " + nanmean(miss_trials));
end