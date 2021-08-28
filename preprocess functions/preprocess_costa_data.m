function all_stats = preprocess_costa_data(stochasticRL_all)
stochasticRL_control = stochasticRL_all(stochasticRL_all(:,16)==1,:);
all_stats = two_blocks_per_session(stochasticRL_control);

end
function all_stats = two_blocks_per_session(stochasticRL_control)
ses_num = sum(stochasticRL_control(:,8)==1);
all_stats = cell(1,ses_num);
for ses_cnt = 1:ses_num
    start_idx = (ses_cnt-1)*80+1; 
    end_idx = (ses_cnt-1)*80+80;
    ses_data = stochasticRL_control(start_idx:end_idx,:);
    end_of_aquisition = find(ses_data(:,10)-1,1,'first')-1;
    all_stats{ses_cnt}.prob6040 = repmat(sum(ses_data(:,12)==6040)>0,2,1);
    all_stats{ses_cnt}.prob7030 = repmat(sum(ses_data(:,12)==7030)>0,2,1);
    all_stats{ses_cnt}.prob8020 = repmat(sum(ses_data(:,12)==8020)>0,2,1);
    all_stats{ses_cnt}.r = ses_data(:,11);
    all_stats{ses_cnt}.abs_superblock_idx = ses_data(1,4);
    all_stats{ses_cnt}.c = -(ses_data(:,14)==10)+(ses_data(:,14)==20); %circle (10) -> -1, square(20) -> 1 ses_data(:,9)*2-1; %1 -> 1, 0 -> -1
    all_stats{ses_cnt}.animal_ids = strcat("BB", int2str(ses_data(1,1)));
    all_stats{ses_cnt}.block_indices = {find(ses_data(:,10)==1),find(ses_data(:,10)==2)};
    all_stats{ses_cnt}.block_addresses = [1; end_of_aquisition+1; 80];
    circle_correct_acq = (ses_data(1,14)==10&ses_data(1,9)==1)|(ses_data(1,14)==20&ses_data(1,9)==0);
    if (all_stats{ses_cnt}.prob6040(1)==1)
        if circle_correct_acq
            all_stats{ses_cnt}.rewardprob = [repmat([.6 .4],end_of_aquisition,1); repmat([.4 .6],80-end_of_aquisition,1)];
        else
            all_stats{ses_cnt}.rewardprob = [repmat([.4 .6],end_of_aquisition,1); repmat([.6 .4],80-end_of_aquisition,1)];
        end
    elseif (all_stats{ses_cnt}.prob7030(1)==1)
        if circle_correct_acq
            all_stats{ses_cnt}.rewardprob = [repmat([.7 .3],end_of_aquisition,1); repmat([.3 .7],80-end_of_aquisition,1)];
        else
            all_stats{ses_cnt}.rewardprob = [repmat([.3 .7],end_of_aquisition,1); repmat([.7 .3],80-end_of_aquisition,1)];
        end
    elseif (all_stats{ses_cnt}.prob8020(1) == 1)
        if circle_correct_acq
            all_stats{ses_cnt}.rewardprob = [repmat([.8 .2],end_of_aquisition,1); repmat([.2 .8],80-end_of_aquisition,1)];
        else
            all_stats{ses_cnt}.rewardprob = [repmat([.2 .8],end_of_aquisition,1); repmat([.8 .2],80-end_of_aquisition,1)];
        end
    else
        error("error translating reward probs");
    end
    if circle_correct_acq
            all_stats{ses_cnt}.hr_side = [-1.*ones(end_of_aquisition,1); ones(80-end_of_aquisition,1)];
    else
        all_stats{ses_cnt}.hr_side = [ones(end_of_aquisition,1); -1.*ones(80-end_of_aquisition,1)];
    end
end
end