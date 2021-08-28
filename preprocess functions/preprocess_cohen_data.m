function all_stats = preprocess_cohen_data(behavStruct)
%% calculate
animal_ids = fieldnames(behavStruct);
sescnt = 0;
for animal_idx = 1:numel(animal_ids)
    animal_data = behavStruct.(animal_ids{animal_idx});
    session_ids = fieldnames(animal_data);
    for session_idx = 1:numel(session_ids)
        sescnt = sescnt +1;
        session_data = animal_data.(session_ids{session_idx});
        block_addresses = [session_data.pd.bs_corrected,...
            length(session_data.pd.allR)+1];
        stats = struct;
        stats.rewardprob = [];
        stats.hr_side = [];
        stats.prob540 = [];
        stats.prob1040 = [];
        stats.r = abs(session_data.pd.allR');
        stats.c = session_data.pd.allC';
        stats.bait_l = [session_data.s.baitL]';
        stats.bait_r = [session_data.s.baitR]';
        stats.bait_l = stats.bait_l(~session_data.pd.CSminus_allMask&~session_data.pd.CSplus_omitMask);
        stats.bait_r = stats.bait_r(~session_data.pd.CSminus_allMask&~session_data.pd.CSplus_omitMask);
        stats.animal_ids = animal_ids{animal_idx};
        stats.num_miss_trials = nansum(session_data.pd.CSplus_allMask)-nansum(session_data.pd.CSplus_responseMask);
        stats.num_nogo_trials = nansum(session_data.pd.CSminus_allMask);
        for block_idx = 1:numel(block_addresses)-1
            block_start_idx = block_addresses(block_idx);
            block_end_idx = block_addresses(block_idx+1);
            block_indices = block_start_idx:block_end_idx-1;
            
            [block_hr_side, block_five, block_ten, prob_left, prob_right] =...
                compute_options(session_data.pd.bp{block_idx}, block_indices);
            block_rewardprob = [prob_left, prob_right].*ones(length(block_indices),2);
            stats.rewardprob = [stats.rewardprob; block_rewardprob];
            stats.hr_side = [stats.hr_side; block_hr_side];
            stats.prob540 = [stats.prob540; logical(block_five)];
            stats.prob1040 = [stats.prob1040; logical(block_ten)];
            stats.block_indices{block_idx} = block_indices;
        end
        stats.block_addresses = block_addresses;
        all_stats{sescnt} = stats;
   end
end