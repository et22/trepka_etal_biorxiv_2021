function output = complex_entropy_metrics(choice, reward, hr_side, str)
% % entropy_metrics %
%PURPOSE:   Compute ERDS, EODS, ERODS, and decompositions 
%AUTHORS:   Ethan Trepka 10/05/2020
%
%INPUT ARGUMENTS
%   choice:   choice vector for block/session where -1= choose left, 1=
%       choose right. choice should not include NaN trials.
%   reward:   reward vector for block/session where 1 = reward, 
%       0 = no reward
%   hr_side:  vector of "better" side (higher reward probability) in each 
%       trial. hr_side is same length as choice and reward vectors. 
%   str: stay/switch vector only REQUIRED when used for running averages
%OUTPUT ARGUMENTS
%   output: entropy metrics and decompositions, stored in the following
%       fields: ["ERDS", "ERDS_win", "ERDS_lose", "EODS", "EODS_better",
%       "EODS_worse", "ERODS", "ERODS_winworse", "ERODS_winbetter", 
%       "ERODS_loseworse", "ERODS_losebetter"]
if ~exist('str', 'var')
    str = choice(1:end-1)==choice(2:end);
end
rew = reward;
opt = choice == hr_side;
if length(rew)>length(str)
    rew(end)=[];
    opt(end) = [];
end
rew_and_opt = binary_to_decimal([rew, opt]);
rewrew_and_optopt = binary_to_decimal([[0; rew(2:end)],[0; opt(2:end)],[0; rew(1:end-1)],[0; opt(1:end-1)]]);
rewrewrew_and_optoptopt = binary_to_decimal([[0; 0; rew(3:end)],[0; 0; opt(3:end)],[0; 0; rew(2:end-1)],[0; 0; opt(2:end-1)],[0; 0; rew(1:end-2)],[0; 0; opt(1:end-2)]]);
rewrew = binary_to_decimal([[0; rew(2:end)],[0; rew(1:end-1)]]);
rewrewrew = binary_to_decimal([[0; 0; rew(3:end)],[0; 0; rew(2:end-1)],[0; 0; rew(1:end-2)]]);
output = copy_field_names(struct,...
        {conditional_entropy(str, rewrew, "ERDS2"),...
        conditional_entropy(str, rewrewrew, "ERDS3"),...
        conditional_entropy(str, rewrew_and_optopt, "ERODS2"),...
        conditional_entropy(str, rewrew_and_optopt, "ERODS2"),...
        conditional_entropy(str, rewrewrew_and_optoptopt, "ERODS3"),...
        mutual_information(str, rew, "MIRS",containers.Map({0,1},{'lose', 'win'})),...
        mutual_information(str, rewrew, "MIRS2"),...
        mutual_information(str, rewrewrew, "MIRS3"),...
        mutual_information(str, opt, "MIOS",containers.Map({0,1},{'worse', 'better'})),...
        mutual_information(str, rew_and_opt, "MIROS",containers.Map({0, 1, 2, 3}, {'loseworse', 'losssebetter','winworse', 'winbetter'})),...
        mutual_information(str, rewrew_and_optopt, "MIROS2"),...
        mutual_information(str,rewrewrew_and_optoptopt,"MIROS3")});
        
end