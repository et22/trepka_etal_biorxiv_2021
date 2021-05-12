function output = latent_metrics(pl, pl_wm, pl_rl, diff, hr_side)
% % behavioral_metrics %
%PURPOSE:   Compute behavioral metrics
%AUTHORS:   Ethan Trepka 10/05/2020
%
%INPUT ARGUMENTS
%   choice:   choice vector for block/session where -1= choose left, 1=
%       choose right. choice should not include NaN trials.
%   reward:   reward vector for block/session where 1 = reward, 
%       0 = no reward
%   hr_side:  vector of "better" side (higher reward probability) in each 
%       trial. hr_side is same length as choice and reward vectors. 
%   stay: stay vector, only REQUIRED for running average plots 

%OUTPUT ARGUMENTS
%   output: range of behavioral metrics, see code
    left_better = -1==hr_side;
    for i = 1:length(left_better)
        if left_better(i)
            output.latent_pbetter(i) = pl(i);
            output.latent_pbetter_wm(i) = pl_wm(i);
            output.latent_petter_rl(i) = pl_rl(i);
        else 
            output.latent_pbetter(i) = 1-pl(i);
            output.latent_pbetter_wm(i) = 1-pl_wm(i);
            output.latent_petter_rl(i) = 1-pl_rl(i);  
        end
    end
    output.latent_diff_rl = mean(diff);
    output.latent_pbetter = mean(output.latent_pbetter);
            output.latent_pbetter_wm = mean(output.latent_pbetter_wm);
            output.latent_petter_rl =mean(output.latent_petter_rl);
    
end