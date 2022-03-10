function [x] = MonteCarloPortfolio(mu, Q, nPortfolios)
%MONTECARLOPORTFOLIO Generates nPortfolios random portfolios, picks the
%best one based on ex-Ante Sharpe Ratio

    % Steps: 
        % Generate nPortfolios random portfolios
        % Calculate Sharpe Ratio for each of them
        % Pick the best one
    
    % Gives pretty decent returns for low nPortfolios - not sure why.
    % Overfitting?
        
   n = size(Q, 1);
   x_best = zeros(n, 1);
   sr_best = -inf;
   
   for i=1:nPortfolios
        x_curr = rand(n, 1);
        x_curr = x_curr ./ sum(x_curr);
        
        sr_curr = (mu'*x_curr)/sqrt(x_curr'*Q*x_curr);
        
        if sr_curr > sr_best
            sr_best = sr_curr;
            x_best = x_curr;
        end
   end
   
   x = x_best;
end

