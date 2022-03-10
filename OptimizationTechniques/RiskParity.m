function [x] = RiskParity(Q, mu, lb, ub)
%RISKPARITY Performs Risk Parity Optimization
    % Optimizes:
    % min 1/2 * (x'Qx) - kappa sum ln(y)
    % s.t. y >= 0 - Optional
    
    % Number of assets
    n = size(Q, 1);
    
    % Can be anything, 1 for simplicity
    kappa = 1;
    
    % Initial portfolio
    y0 = repmat(1.0/n, n, 1);
    
    % No equality constraints
    Aeq = [];
    beq = [];
    
    % No inequality constraints
    A = [];
    b = [];
    
    % No short selling, no upper bound
    lb = [];
    ub = [];
    
    % Optimization Options
    options = optimoptions('fmincon', 'Display', 'off');
    
    % Run non-linear optimization
    % The second-to-last argument is nonlcon, we don't need it
    y = fmincon(@(y) objFun(y, Q, kappa), y0, A, b, Aeq, beq, lb, ub, [], options);
    
    % Normalize weights
    x = y ./ sum(y);
end

% Non-linear Objective Function

function f = objFun(x, Q, kappa)
    % Num Assets
    n = size(Q, 1);
    
    % Variance
    f = 0.5 .* (x' * (Q*x));
    
    % ln Component
    for i=1:n
        f = f - kappa*log(x(i));
    end
end

