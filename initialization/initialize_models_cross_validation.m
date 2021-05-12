function [output, models] = initialize_models_cross_validation(dataset_name)
models{1}.name = 'Return';           % text label to refer to the models
models{1}.fun = 'funReturn';     % the corresponding .m code for the models
models{1}.initpar=[0.5 5 0.5];   % initial [alpha_reward beta alpha_noreward]
models{1}.lb=[0 0 0];            % upper bound of parameters
models{1}.ub=[1 inf 1];          % lower bound of parametersmodels{1}.name = 'Income';           % text label to refer to the models
models{1}.label = "RL1";
models{1}.behav_flag = 0;

models{2}.name = 'Income';           % text label to refer to the models
models{2}.fun = 'funIncome';     % the corresponding .m code for the models
models{2}.initpar=[.2 5 .05 .5];   % initial [alpha_reward beta alpha_noreward]
models{2}.lb=[0 0 0 0];            % upper bound of parameters
models{2}.ub=[1 inf 1 1];          % lower bound of parameters
models{2}.label = "RL2";
models{2}.behav_flag = 0;

models{3}.name = 'ChoiceKernel';           % text label to refer to the models
models{3}.fun = 'funChoiceKernel';     % the corresponding .m code for the models
models{3}.initpar=[.5 5 .5 .5 .5];   % initial [alpha_reward beta alpha_noreward]
models{3}.lb=[0 0 0 0 0];            % upper bound of parameters
models{3}.ub=[1 inf 1 1 1];          % lower bound of parameters
models{3}.label = "RL3";
models{3}.behav_flag = 0;

models{4}.name = 'IncomeVarA';           % text label to refer to the models
models{4}.fun = 'funIncomeVarA';     % the corresponding .m code for the models
models{4}.initpar=[.2 5 .05 .5 1];   % initial [alpha_reward beta alpha_noreward]
models{4}.lb=[0 0 0 0 0];            % upper bound of parameters
models{4}.ub=[1 inf 1 1 1];          % lower bound of parameters
models{4}.label = "Dyn. WSLS";
models{4}.behav_flag = 0;

models{5}.name = 'behavior';
models{5}.label = 'Obs.';
models{5}.behav_flag = 1;

output = struct;
for i=1:length(models)
    output.(models{i}.name) = struct;
end
for k=1:length(models)
    filename = strcat('output/model/',dataset_name,'/',models{k}.name,'.mat');
    if exist(filename, 'file')
        load(filename, 'model_struct');
        output.(models{k}.name) = model_struct;
        label = models{k}.label;
        behav_flag = models{k}.behav_flag;
        models{k} = output.(models{k}.name).model;
        models{k}.exists = 1;
        models{k}.label = label;
        models{k}.behav_flag = behav_flag;
    else
        models{k}.exists = 0;
    end
end
end