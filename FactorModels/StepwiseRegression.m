function  [mu, Q] = StepwiseRegression(returns, factRet)
    
    % Use this function to perform a basic OLS regression with all factors. 
    % You can modify this function (inputs, outputs and code) as much as
    % you need to.
 
    % *************** WRITE YOUR CODE HERE ***************
    %----------------------------------------------------------------------
    
    % T months, p - Number of predictors
    [T, p] = size(factRet); 
    
    % Data matrix
    X = [ones(T,1) factRet];

    % Save our betas and alpha here
    B = [];
    
    % Stepwise Regression
    % Loop through each asset, get beta and alpha using
    for k=1:size(returns, 2)
        [b,~,~,finalmodel,stats] = stepwisefit(factRet, returns(:, k), 'Display', 'off');
        % add is a vector with the alpha (stats.model)
        % and beta (b) if the beta is chosen, and 0 if beta is not chosen.

        add = [stats.intercept; b.*finalmodel'];
        B = [B add];
    end
   
    % Separate B into alpha and betas
    a = B(1,:)';     
    V = B(2:end,:); 
    
    % Residual variance
    ep       = returns - X * B;
    sigma_ep = 1/(T - p - 1) .* sum(ep .^2, 1);
    D        = diag(sigma_ep);
        
    % Factor expected returns and covariance matrix
    f_bar = mean(factRet,1)';
    F     = cov(factRet);
    
    % Calculate the asset expected returns and covariance matrix
    mu = a + V' * f_bar;
    Q  = V' * F * V + D;
    
    % Sometimes quadprog shows a warning if the covariance matrix is not
    % perfectly symmetric.
    Q = (Q + Q')/2;
    
    %----------------------------------------------------------------------
    
end