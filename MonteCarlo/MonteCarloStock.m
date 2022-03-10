function [x] = MonteCarloStock(mu, Q, nPaths, lb, ub)
%MONTECARLOSTOCK Returns a portfolio weighted by projected returns over a
%6-month period
    
    % We only want to project 6 months as this is the rebalance period
    T = 26;
    N = 1; % Don't care about price evolution
    dt = T/N;
    
    % Number of paths for simulation
    nPaths = nPaths;
    
    n = size(Q, 1); % Num Assets
    
    % Continuous-time geometric random walk for n correlated stocks
    % Do Cholesky Factorization
    L = chol(Q, 'lower');
    
    % Assume each of these stocks starts at $1
    S_now = ones(n, nPaths);
    S_sim = zeros(n, nPaths);
    
    % Volatilites
    vol = diag(Q);
    
    a = 0.1/12;
    b = -0.1/12;

    
    for i=1:nPaths
        for j=1:n
            mu_use = mu + (b-a).*rand(n,1) + a;
            % Convert the independent RVs to correlated RVs
            xi = L * randn(n, 1);
            S_sim(j, i) = S_now(j, i)* exp( ( mu_use(j) - 0.5 * vol(j)^2 ) * dt ...
                        + vol(j) * sqrt(dt) * xi(j) );
        end
    end        
    % See how much it grew
    averagePctChange = mean(S_sim')' - 1;
    
    % Upper/Lower bound constraints
    averagePctChange = max(averagePctChange, lb);
    averagePctChange = min(averagePctChange, ub);

    % Normalize
    x = averagePctChange ./ sum(averagePctChange);
end

