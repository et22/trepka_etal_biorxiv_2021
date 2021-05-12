function s=algo_IncomeChoiceRewardMemoryV6(s,xpar)
t = s.currTrial;
gamma = mean([xpar(1), xpar(3)]);
omega = xpar(5);
omega1 = xpar(6);
if t == 1  %if this is the first trial
    s.ql(t) = 0.5;
    s.qr(t) = 0.5;
    s.rpe(t) = NaN;
    s.pl(t) = 0.5;
    s.cl(t) = .5;
    s.cr(t) = .5;
    s.erpe(t) = .5;
else
    [s.ql(t), s.qr(t),rpe] = IncomeUpdateStep(s.r(t-1),s.c(t-1),s.ql(t-1),s.qr(t-1),xpar);
        stay_bias_right = (s.r(t-1)*2-1)*(s.c(t-1)==1);
    stay_bias_left = (s.r(t-1)*2-1)*(s.c(t-1)==-1);
    s.cr(t) = update(s.cr(t-1), gamma, s.c(t-1)==1);
    s.cl(t) = update(s.cl(t-1), gamma, s.c(t-1)==-1);
    s.erpe(t) = update(s.erpe(t-1), gamma, abs(rpe));
    if s.r(t-1)==0
    q_right = s.qr(t) + s.cr(t)*omega+s.erpe(t)*stay_bias_right*omega1;
    q_left = s.ql(t) + s.cl(t)*omega+s.erpe(t)*stay_bias_left*omega1;
    else
     q_right = s.qr(t) + s.cr(t)*omega;
    q_left = s.ql(t) + s.cl(t)*omega;       
    end
    [s.pl(t), s.pr(t)] = DecisionRule(q_left, q_right, xpar(2));    
end

end