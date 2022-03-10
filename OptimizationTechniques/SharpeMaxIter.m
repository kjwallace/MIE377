function [x] = SharpeMaxIter(mu,Q, t_penalty, t_lambda, sigma, ci, T)
% SHARPEMAXITER Performs Sharpe Ratio Maximization 100-1000 times 
% With varying target returns sampled fromm a Normal Distribution

% Notes: Does not work at all, aka the sharpe ratio does not change
% I'm thinking maybe its because there is now a Kappa, so its not
% As sensitive to the target return anymore?
% Who knows, will come back to this later
    
    % Asset number and means
    n = size(Q, 1);
    mu_mean = mean(mu);
    
    % Initialize best seen so far
    x_best = zeros(n, 1);
    sr_best = -inf;
    
    ret = linspace(0, 0.6/12, 100);
    
    for i=1:500
        targetRet = normrnd(mu_mean, sigma);
        x_curr = SharpeMax(mu, Q, t_penalty, t_lambda, targetRet, ci, T);
        
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

