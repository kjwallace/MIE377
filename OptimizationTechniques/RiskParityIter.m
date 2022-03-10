function [x] = RiskParityIter(Q, mu)
% SHARPEMAXITER Performs Risk Parity Optimization 100-1000 times 
% With varying target returns sampled fromm a Normal Distribution
    
    % Asset number and means
    n = size(Q, 1);
    mu_mean = mean(mu);
    
    % Initialize best seen so far
    x_best = zeros(n, 1);
    sr_best = -inf;
    
    ret = linspace(0, 0.6/12, 100);
    
    for i=1:length(ret)
        targetRet = ret(i);
        x_curr = RiskParity(Q, mu, targetRet);
        
        % If target return makes our problem infeasible, return
        if size(x_curr, 1) == 0
            continue
        end
               
        sr_curr = (mu'*x_curr)/sqrt(x_curr'*Q*x_curr);
        
        if sr_curr > sr_best
            sr_best = sr_curr;
            x_best = x_curr;
        end
    end
    
    x = x_best;
    
    %----------------------------------------------------------------------
end

