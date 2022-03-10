function  x = MVOITER(mu, Q, x0, ret, T)
    % Find the total number of assets
    n = size(Q,1); 
        
    % Set the target return as required
    targetRet = ret;
    
    % Toggle turnover on/off
    limit_turnover = true;
    
    % Save diag(Q) before adding turnover changes
    D = diag(Q);
    
    % Initialize empty linear objective function
    f = [];
    
    if limit_turnover
        lambda = 1e-1; % Penalty for turnover
        Q = Q + lambda*eye(n); % Add x'x terms
        f = -2*x0*lambda; % Add linear objective 
    end
    
    %Epsilon for robust MVO
    alpha = .9; % 
    ep = norminv(1-alpha/2);
    T = sqrt(T); % sqrt(36 months)

    
    % Disallow short sales
    lb = zeros(n,1);
    
    % Set upper bound dynamically
    ub = .2*ones(n,1); %max to ensure feasiblity/flexibility
    
    % Set equality constraints
    Aeq = ones(1,n);
    beq = 1;

    % Set the quadprog options 
    options = optimoptions( 'quadprog', 'TolFun', 1e-9, 'Display','off');
   
    % Add the expected return constraint
    % Add the expected return constraint
    A = [-1 .* mu'-(ep*(D'.^2))/T; 
         -1 .* mu'+(ep*(D'.^2))/T];
     
    b = [-1 * targetRet; 
         -1 * targetRet;];

    %constrain weights to sum to 1
    % Optimal asset weights
    x = quadprog(2*Q, f, A, b, Aeq, beq, lb, ub, [], options);
                         % []        A        b       lb
    x = x./sum(x);
    %----------------------------------------------------------------------
    
end
