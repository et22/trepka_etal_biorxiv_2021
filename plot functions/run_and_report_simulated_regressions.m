function run_and_report_simulated_regressions(output)
    if ~exist('stepwise_crit','var')
        stepwise_crit = .0001;
    end
    disp(newline);
    disp("=======SIMULATED STEPWISE REGRESIONS=========");
    for j=1:2
        if j==2
            labels = ["ERDS_+", "ERDS_-", "p(win)", "p(stay)", "WinStay",...
                "LoseSwitch", "RI_B", "RI_W", "ERODS_{B+}",...
                "ERODS_{W+}", "ERODS_{B-}", "ERODS_{W-}", "EODS_B", "EODS_W", ];
            dataMtx = [...
                output.block_simulations.ERDS_win,...                 %1
                output.block_simulations.ERDS_lose,...                %2
                output.block_simulations.pwin,...                      %3
                output.block_simulations.pstay,...                     %4
                output.block_simulations.winstay,...      %5
                output.block_simulations.loseswitch,...    &6
                output.block_simulations.RI_B,...                      %8
                output.block_simulations.RI_W,...                      %9
                output.block_simulations.ERODS_winbetter,...           %12
                output.block_simulations.ERODS_winworse,...            %13
                output.block_simulations.ERODS_losebetter,...          %12
                output.block_simulations.ERODS_loseworse,...           %13
                output.block_simulations.EODS_better,...             %10
                output.block_simulations.EODS_worse,...            %11
                ];
            parameterLabels = "Model(RL sim full) U.M., top 3 predictors";
            num_steps = 3;
        elseif j==1
            labels = ["alpha_{rew}", "alpha_{unrew}", "1/\sigma",...
                "\sigma", "\alpha_{rew} + \alpha_{unrew}",...
                "\alpha_{rew} - \alpha_{unrew}", "(\alpha_{rew} - \alpha_{unrew})/\sigma",...
                "(\alpha_{rew} + \alpha_{unrew})/\sigma"];
            dataMtx = [...
                output.block_simulations.alpha',...                 %1
                output.block_simulations.alpha2',...                %2
                output.block_simulations.beta',...                      %3
                output.block_simulations.sigma',...                     %4
                output.block_simulations.alpha_sum',...      %5
                output.block_simulations.alpha_difference',...    &6
                output.block_simulations.alpha_difference_over_sigma',...                      %8
                output.block_simulations.alpha_sum_over_sigma'];
            parameterLabels = "Model (RL sim parameters) U.M., top 3 predictors";
            num_steps = 3;
        end
        
        [b,se,pval,finalmodel,stats,nextstep,history] = stepwisefit(dataMtx,...
            output.block_simulations.matching_measure, 'PEnter', stepwise_crit,'PRemove', stepwise_crit+stepwise_crit/10, 'Display', 'off', 'MaxIter', num_steps); %if using stepwiselm, 'Upper', 'linear',
        mdl = stepwiselm(dataMtx,...
            output.block_simulations.matching_measure, 'Upper', 'linear', 'PEnter', stepwise_crit,'PRemove', stepwise_crit+stepwise_crit/10, 'Verbose', 0, 'NSteps', num_steps); %if using stepwiselm, ,
        disp(parameterLabels);
        disp(strcat("Adj. R squared: ", num2str(mdl.Rsquared.Adjusted)));
        
        disp('Stepwise process:');
        prev = zeros(1, size(history.in, 2));
        process_string = "";
        for i=1:size(history.in, 1)
            diff = history.in(i, :) - prev;
            if (sum(diff)<0)
                process_string = strcat(process_string, "Removed ");
            elseif (sum(diff)>0)
                process_string = strcat(process_string, "Added ");
            end
            process_string = strcat(process_string, labels(find(diff)), ", RMSE = ",...
                ""+sprintf('%0.4f',history.rmse(i)), ", p < ", sprintf('%0.2e',mdl.Steps.History.pValue(i+1)),...
                ". ");
            prev = history.in(i, :);
        end
        disp(process_string);
        %final equation
        reg_eq = b'.*finalmodel;
        disp('Final regression equation:');
        eq_string = "UM =";
        reg_eq_idx = find(finalmodel);
        for i=1:sum(finalmodel)
            eq_string = strcat(eq_string, "+", sprintf('%0.2f', reg_eq(reg_eq_idx(i))), "*", labels(reg_eq_idx(i)));
        end
        eq_string = strcat(eq_string, " +", sprintf('%0.2f', stats.intercept));
        disp(eq_string);
        disp(newline);
    end    
end