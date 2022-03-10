function [x] = SharpeMax(mu, Q, t_penalty, t_lambda, ret, ci, T)
% SHARPEMAX Performs Sharpe Ratio Maximization
    
    % Find the total number of assets
    n = size(Q,1);

    % Adding padding on Q to accomodate Kappa
    Q_asset = Q;
    Q = [Q zeros(n,1); zeros(1, n+1)];
    
    % Set the target as the average expected return of all assets
    targetRet = ret;
    
    % Add robustness
    % Delta vector to make it robust
    ep = norminv(ci);
    
    delta = ep*sqrt(diag(Q_asset))/sqrt(floor(T*12));
    mu = mu - delta;

    % Disallow short sales
    % Also, kappa > 0
    lb = zeros(n+1, 1);
    
    % Add the expected return constraint
    % Note that this is
    % -r1y1 -r2y2 - r3y3 - ... - rnyn + kappa*targetRet < 0

    A = [ -mu' targetRet ];
    b = 0;

    % Constraint 1: (mu - rf)'*y = 1
    % Constraint 2: Sum of y must equal kappa
    % y1 + y2 + ... + yn - kappa = 0

    Aeq = [ mu' 0 ;
            ones(1,n) -1 ];
    beq = [ 1; 0 ];

    % Set the quadprog options 
    options = optimoptions( 'quadprog', 'TolFun', 1e-9, 'Display','off');
    
    % Optimal asset weights
    y = quadprog( 2 * Q, [], A, b, Aeq, beq, lb, [], [], options)
    
    % Remove Kappa
    y = y(1:n, :);
    
    % Normalize
    x = y ./ sum(y);
    
    %----------------------------------------------------------------------
end

