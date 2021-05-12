function [output, models] = initialize_models(dataset_name, load_output)
if ~exist("load_output",'var')
    load_output = true;
end
models{1}.name = 'Return';       % text label to refer to the models
models{1}.fun = 'funReturn';     % the corresponding .m code for the models
models{1}.initpar=[0.5 5 0.5];   % initial [alpha_reward beta alpha_noreward]
models{1}.lb=[0 0 0];            % upper bound of parameters
models{1}.ub=[1 100 1];          % lower bound of parametersmodels{1}.name = 'Income';           % text label to refer to the models
models{1}.label = "RL1";
models{1}.behav_flag = 0;
models{1}.color = [0.2    0.2    0.2];
models{1}.plabels = ["arew", "beta", "aunrew"];

models{2}.name = 'Income';         % text label to refer to the models
models{2}.fun = 'funIncome';       % the corresponding .m code for the models
models{2}.initpar=[.5 5 .5 .5];   % initial [alpha_reward beta alpha_noreward]
models{2}.lb=[0 0 0 0];            % upper bound of parameters
models{2}.ub=[1 100 1 1];          % lower bound of parameters
models{2}.label = "RL2";
models{2}.behav_flag = 0;
models{2}.color = [0.3    0.3    0.3];
models{2}.plabels = ["arew", "beta", "aunrew", "decay"];

models{3}.name = 'ChoiceKernel';           % text label to refer to the models
models{3}.fun = 'funChoiceKernel';     % the corresponding .m code for the models
models{3}.initpar=[.5 5 .5 .5 .5];   % initial [alpha_reward beta alpha_noreward]
models{3}.lb=[0 0 0 0 0];            % upper bound of parameters
models{3}.ub=[1 100 1 1 1];          % lower bound of parameters
models{3}.label = "RL3";
models{3}.behav_flag = 0;
models{3}.color = [0.4    0.4    0.4];
models{3}.plabels = ["arew", "beta", "aunrew", "clr","cweight"];

% 
% models{4}.name = 'IncomeChoiceLoss';           % text label to refer to the models
% models{4}.fun = 'funIncomeChoiceLoss';     % the corresponding .m code for the models
% models{4}.initpar=[.5 5 .5 .5 0 0];   % initial [alpha_reward beta alpha_noreward]
% models{4}.lb=[0 0 0 0 -1 -1];            % upper bound of parameters
% models{4}.ub=[1 100 1 1 1 1];          % lower bound of parameters
% models{4}.label = "Dyn. RCM";
% models{4}.behav_flag = 0;
% % 
% models{5}.name = 'IncomeChoiceLossV2';           % text label to refer to the models
% models{5}.fun = 'funIncomeChoiceLossV2';     % the corresponding .m code for the models
% models{5}.initpar=[.5 5 .5 .5 0 0];   % initial [alpha_reward beta alpha_noreward]
% models{5}.lb=[0 0 0 0 -1 -1];            % upper bound of parameters
% models{5}.ub=[1 100 1 1 1 1];          % lower bound of parameters
% models{5}.label = "Dyn. RCMv2";
% models{5}.behav_flag = 0;
% 
% models{6}.name = 'IncomeChoiceLossV3';           % text label to refer to the models
% models{6}.fun = 'funIncomeChoiceLossV3';     % the corresponding .m code for the models
% models{6}.initpar=[.5 5 .5 .5 0 0];   % initial [alpha_reward beta alpha_noreward]
% models{6}.lb=[0 0 0 0 -1 -1];            % upper bound of parameters
% models{6}.ub=[1 100 1 1 1 1];          % lower bound of parameters
% models{6}.label = "Dyn. RCMv3";
% models{6}.behav_flag = 0;

l = length(models);
models{l+1}.name = 'IncomeChoiceMemoryBoth';           % text label to refer to the models
models{l+1}.fun = 'funIncomeChoiceMemoryBoth';     % the corresponding .m code for the models
models{l+1}.initpar=[.5 5 .5 .5 0];   % initial [alpha_reward beta alpha_noreward]
models{l+1}.lb=[0 0 0 0 -1];            % upper bound of parameters
models{l+1}.ub=[1 100 1 1 1];          % lower bound of parameters
models{l+1}.label = "RL2+CM";
models{l+1}.behav_flag = 0;
models{l+1}.color = [0.5    0.5    0.5];
models{l+1}.plabels = ["arew", "beta", "aunrew","decay", "cweight"];


l = length(models);
models{l+1}.name = 'IncomeChoiceMemory';           % text label to refer to the models
models{l+1}.fun = 'funIncomeChoiceMemory';     % the corresponding .m code for the models
models{l+1}.initpar=[.5 5 .5 .5 0];   % initial [alpha_reward beta alpha_noreward]
models{l+1}.lb=[0 0 0 0 0];            % upper bound of parameters
models{l+1}.ub=[1 100 1 1 1];          % lower bound of parameters
models{l+1}.label = "RL2+CM+";
models{l+1}.behav_flag = 0;
models{l+1}.color = [0.6    0.6    0.6];
models{l+1}.plabels = ["arew", "beta", "aunrew", "decay", "cweight"];

% l = length(models);
% models{l+1}.name = 'IncomeRewardMemoryBoth';           % text label to refer to the models
% models{l+1}.fun = 'funIncomeRewardMemoryBoth';     % the corresponding .m code for the models
% models{l+1}.initpar=[.5 5 .5 .5 0];   % initial [alpha_reward beta alpha_noreward]
% models{l+1}.lb=[0 0 0 0 -1];            % upper bound of parameters
% models{l+1}.ub=[1 100 1 1 1];          % lower bound of parameters
% models{l+1}.label = "RL2+RM";
% models{l+1}.behav_flag = 0;
% 
% l = length(models);
% models{l+1}.name = 'IncomeRewardMemory';           % text label to refer to the models
% models{l+1}.fun = 'funIncomeRewardMemory';     % the corresponding .m code for the models
% models{l+1}.initpar=[.5 5 .5 .5 0];   % initial [alpha_reward beta alpha_noreward]
% models{l+1}.lb=[0 0 0 0 0];            % upper bound of parameters
% models{l+1}.ub=[1 100 1 1 1];          % lower bound of parameters
% models{l+1}.label = "RL2+RM+";
% models{l+1}.behav_flag = 0;
% 
% l = length(models);
% models{l+1}.name = 'IncomeRewardMemoryV2';           % text label to refer to the models
% models{l+1}.fun = 'funIncomeRewardMemoryV2';     % the corresponding .m code for the models
% models{l+1}.initpar=[.5 5 .5 .5 0];   % initial [alpha_reward beta alpha_noreward]
% models{l+1}.lb=[0 0 0 0 -1];            % upper bound of parameters
% models{l+1}.ub=[1 100 1 1 1];          % lower bound of parameters
% models{l+1}.label = "RL2+RMv2";
% models{l+1}.behav_flag = 0;
% 
% l = length(models);
% models{l+1}.name = 'IncomeRewardMemoryV3';           % text label to refer to the models
% models{l+1}.fun = 'funIncomeRewardMemoryV3';     % the corresponding .m code for the models
% models{l+1}.initpar=[.5 5 .5 .5 0];   % initial [alpha_reward beta alpha_noreward]
% models{l+1}.lb=[0 0 0 0 -1];            % upper bound of parameters
% models{l+1}.ub=[1 100 1 1 1];          % lower bound of parameters
% models{l+1}.label = "RL2+RMv3";
% models{l+1}.behav_flag = 0;

% l = length(models);
% models{l+1}.name = 'IncomeLossMemory';           % text label to refer to the models
% models{l+1}.fun = 'funIncomeLossMemory';     % the corresponding .m code for the models
% models{l+1}.initpar=[.5 5 .5 .5 0];   % initial [alpha_reward beta alpha_noreward]
% models{l+1}.lb=[0 0 0 0 -1];            % upper bound of parameters
% models{l+1}.ub=[1 100 1 1 1];          % lower bound of parameters
% models{l+1}.label = "RL2+LM";
% models{l+1}.behav_flag = 0;

l = length(models);
models{l+1}.name = 'IncomeLossMemoryV2';           % text label to refer to the models
models{l+1}.fun = 'funIncomeLossMemoryV2';     % the corresponding .m code for the models
models{l+1}.initpar=[.5 5 .5 .5 0];   % initial [alpha_reward beta alpha_noreward]
models{l+1}.lb=[0 0 0 0 -1];            % upper bound of parameters
models{l+1}.ub=[1 100 1 1 1];          % lower bound of parameters
models{l+1}.label = "RL2+LM";
models{l+1}.behav_flag = 0;
models{l+1}.color = [0.7    0.7    0.7];
models{l+1}.plabels = ["arew", "beta", "aunrew", "decay", "lweight"];

l = length(models);
models{l+1}.name = 'IncomeLossMemoryV22';           % text label to refer to the models
models{l+1}.fun = 'funIncomeLossMemoryV22';     % the corresponding .m code for the models
models{l+1}.initpar=[.5 5 .5 .5 0];   % initial [alpha_reward beta alpha_noreward]
models{l+1}.lb=[0 0 0 0 -1];            % upper bound of parameters
models{l+1}.ub=[1 100 1 1 1];          % lower bound of parameters
models{l+1}.label = "RL2+LM+";
models{l+1}.behav_flag = 0;
models{l+1}.color = [0.8    0.8    0.8];
models{l+1}.plabels = ["arew", "beta", "aunrew", "decay", "lweight"];

% 
% 
% l = length(models);
% models{l+1}.name = 'IncomeLossMemoryV3';           % text label to refer to the models
% models{l+1}.fun = 'funIncomeLossMemoryV3';     % the corresponding .m code for the models
% models{l+1}.initpar=[.5 5 .5 .5 0];   % initial [alpha_reward beta alpha_noreward]
% models{l+1}.lb=[0 0 0 0 -1];            % upper bound of parameters
% models{l+1}.ub=[1 100 1 1 1];          % lower bound of parameters
% models{l+1}.label = "RL2+LMv3";
% models{l+1}.behav_flag = 0;
% 
% l = length(models);
% models{l+1}.name = 'IncomeChoiceRewardMemoryV4';           % text label to refer to the models
% models{l+1}.fun = 'funIncomeChoiceRewardMemoryV4';     % the corresponding .m code for the models
% models{l+1}.initpar=[.5 5 .5 .5 0 0];   % initial [alpha_reward beta alpha_noreward]
% models{l+1}.lb=[0 0 0 0 -1 -1];            % upper bound of parameters
% models{l+1}.ub=[1 100 1 1 1 1];          % lower bound of parameters
% models{l+1}.label = "Dyn. LCM1";
% models{l+1}.behav_flag = 0;

% l = length(models);
% models{l+1}.name = 'IncomeChoiceRewardMemoryV5';           % text label to refer to the models
% models{l+1}.fun = 'funIncomeChoiceRewardMemoryV5';     % the corresponding .m code for the models
% models{l+1}.initpar=[.5 5 .5 .5 0 0];   % initial [alpha_reward beta alpha_noreward]
% models{l+1}.lb=[0 0 0 0 -1 -1];            % upper bound of parameters
% models{l+1}.ub=[1 100 1 1 1 1];          % lower bound of parameters
% models{l+1}.label = "Dyn. LCMv2";
% models{l+1}.behav_flag = 0;

l = length(models);
models{l+1}.name = 'IncomeChoiceRewardMemoryV6';           % text label to refer to the models
models{l+1}.fun = 'funIncomeChoiceRewardMemoryV6';     % the corresponding .m code for the models
models{l+1}.initpar=[.5 5 .5 .5 0 0];   % initial [alpha_reward beta alpha_noreward]
models{l+1}.lb=[0 0 0 0 -1 -1];            % upper bound of parameters
models{l+1}.ub=[1 100 1 1 1 1];          % lower bound of parameters
models{l+1}.label = "Dyn. LCM";
models{l+1}.behav_flag = 0;
models{l+1}.color = [0.9492    0.4453    0.3711];
models{l+1}.plabels = ["arew", "beta", "aunrew", "decay", "cweight","lweight"];


%models(2:end) = [];

l = length(models);
models{l+1}.name = 'behavior';
models{l+1}.label = 'Obs.';
models{l+1}.behav_flag = 1;
if(strcmp(dataset_name, "cohen"))
    models{l+1}.color = [227, 130, 29]./256;
elseif(strcmp(dataset_name, "costa"))
    models{l+1}.color = [58, 166, 154]./256;
else
    error("Enter valid dataset name...");
end

% old_models = models;
% for i=1:length(old_models)-1
%     models{i} = old_models{length(old_models)-i};
% end

output = struct;
for i=1:length(models)
    output.(models{i}.name) = struct;
end

for k=1:length(models)
    filename = strcat('output/model/',dataset_name,'/',models{k}.name,'.mat');
    if exist(filename, 'file') && load_output
        load(filename, 'model_struct');
        output.(models{k}.name) = model_struct;
        orig_struct = models{k};
        models{k} = output.(models{k}.name).model;
        models{k}.exists = 1;  
        field_names = fieldnames(orig_struct);
        for cnt = 1:length(field_names)
            if ~isfield(models{k}, field_names{cnt})
                models{k}.(field_names{cnt}) = orig_struct.(field_names{cnt});
            end
        end
    else
        models{k}.exists = 0;
    end
end
end