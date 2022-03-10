function x = Project1_Function(periodReturns, periodFactRet, x0)
    %----------------------------------------------------------------------
    config = ReadJson('config.json');

    % Set semple period to 4.5 Years
    years = config.test_years;
    
% Convert to months
    T = floor(years*12);
    
    % For indexing
    t = T-1;
    
    % Get sample returns
    returns = periodReturns(end-t:end,:);
    factRet = periodFactRet(end-t:end,:);     
    
    % Get asset returns and covariances
    [mu, Q] = OLS(returns, factRet);
    
    % Generate vector of target returns to test
    ret = linspace(0, 0.6/12, 250); 
     
    % Save best portfolio weights and
    % Performance Metric 
    x_best = zeros(size(periodReturns, 2));
    sr_best = -1000;
     
    % Initialize portfolio weight history
    
    % Initialize synthetic portfolio weight history
    ratio = 0.7;
    t_k = floor(ratio*T);
    
    % Store of synthetic portfolio weight evolution
    k = repmat(x0, 1, t_k);
    
    % Initialize store
    k_curr = [];
     
    % Find optimal return target
    for i=1:length(ret)
        % Return to test
        r = ret(i);
        
        % Get proposed portfolio weight
        x_curr = MVOITER(mu, Q, x0, r, T);
        
        % If target return makes problem infeasible, continue to next
        if size(x_curr, 1) == 0
            continue
        end
 
        % Dynamic linear projection
        
        % Construct proposed synthetic portfolio evolution
        k_curr = [k repmat(x_curr, 1, T-t_k)];
        
        % Get market excess returns
        excess_ret = diag(returns*k_curr)-factRet(:,1);

        % Get variance of excess returns
        benchmark_std = std(excess_ret);
         
        % Calculate Ex Ante Sharpe Ratio
        % sr_curr = (mu'*x_curr)/sqrt(x_curr'*Q*x_curr);
         
        % Calculate Ex Ante Information Ratio
        sr_curr = (mu'*x_curr-mean(factRet(:,1)))/benchmark_std;
         
        % Update best
        if sr_curr > sr_best
            sr_best = sr_curr;
            x_best = x_curr;
            k = k_curr;
        end
    end
    x = x_best;
    
    %----------------------------------------------------------------------
end
