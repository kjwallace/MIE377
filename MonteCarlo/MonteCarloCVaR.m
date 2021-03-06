function [x] = MonteCarloCVaR(mu, Q, returns, factorReturns, nPaths, alpha, cvar_ci, cvar_lb, cvar_ub)
%MONTECARLOCVAR - Generates nPaths scenarios and uses them in CVaR
%optimization
    
    % We only want to project 6 months as this is the rebalance period
    T = 26;
    N = 1; % Don't care about price evolution
    dt = T/N;
    
    % Number of paths for simulation
    nPaths = nPaths;

    % Get market betas for each stock
    B = MarketBeta(returns, factorReturns);
    
    % Get asset covariance with market
    % cov(asset, market) = sigma_M^2 * Beta
    
    B = cov(factorReturns(:, 1)) * B;
    
    % Save asset information
    mu_assets = mu;
    Q_assets = Q;
    
    % Add betas to correlation matrix
    Q = [Q B'; B 1];
    
    % Add factor return to mu vector
    mu = [mu; mean(factorReturns(:, 1))];
    
    % mu_bull
    mu_bull = mu + 0.05/12;

    % mu_bear
    mu_bear = mu - 0.05/12;
    
    % Num Assets + Market
    n = size(Q, 1);
    
    % Continuous-time geometric random walk for n correlated stocks
    % Do Cholesky Factorization
    L = chol(Q, 'lower');
    
    % Assume each of these stocks + Market starts at $1
    S_now = ones(n, nPaths);
    
    % Store for final prices
    S_sim = zeros(n, nPaths);
    
    % Volatilites
    vol = diag(Q);
    
    a = 0.1/12;
    b = -0.2/12;
    
    for i=1:nPaths
        for j=1:n
            % switch randsample(3, 1)
            %    case 1
            %        mu_use = mu_bear;
            %    case 2
            %        mu_use = mu_bull;
            %    case 3
            %        mu_use = mu;
            % end
            %}
            
            mu_use = mu + (b-a).*rand(n,1) + a;
            % Convert the independent RVs to correlated RVs
            xi = L * randn(n, 1);
            
            % Stochastic growth equation. Subtracting 1 to get % Change.
            S_sim(j, i) = S_now(j, i)* exp( ( mu_use(j) - 0.5 * vol(j)^2 ) * dt ...
                        + vol(j) * sqrt(dt) * xi(j) ) - 1;
        end
    end
    
    returns = [returns; S_sim(1:end-1, :)'];
    % returns = S_sim(1:end-1, :)';
    
    factRet = [factorReturns(:, 1); S_sim(end, 1:end)'];

    x = CVarOpt(returns, factRet, alpha, Q_assets, cvar_ci, cvar_lb, cvar_ub);
end

