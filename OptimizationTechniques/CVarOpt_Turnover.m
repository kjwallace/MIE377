function [x] = CVarOpt_Turnover(returns, factRet, alpha, x_0)
%CVAROPT Performs CVar Optimization with Turnover Penalty


    % S is the number of months in our case
    % n is the number of assets
    [S, n] = size(returns);
    
    % Get market return
    R = geomean(factRet(1:end, 1) + 1) - 1;
    mu = ( geomean(returns + 1) - 1 )';
    
    % Optimizing over x (n variables), z (S variables) and gamma (1
    % variable). Total: n+S+1 variables
    %   min     gamma + (1 / [(1 - alpha) * S]) * sum( z_s )
    %   s.t.    z_s   >= 0,                 for s = 1, ..., S
    %           z_s   >= -r_s' x - gamma,   for s = 1, ..., S  
    %           1' x  =  1,
    %           mu' x >= R
    
    % load ub/lb conditions from config
    config = ReadJson('config.json');
    
    % z > 0, and gammma has no lower bound
    
   % if config.lb_setting == 1
        
    %   lowlim = config.lb_value;
        
    %   lb = [lowlim*ones(n,1); zeros(S,1); - inf];
        
   % else
    %   lb = [zeros(n,1); zeros(S, 1); -inf];
   % end   
        
   % if config.ub_setting == 1
        
   %    uplim = config.ub_value;
    %    
   %    ub = [uplim*ones(n,1); inf*ones(S, 1); inf];
        
   %else
   %    ub = [ones(n,1); inf*ones(S, 1); inf];
   % end 
   lambda = config.turnover_lambda; 
      
   % No upper bound
   ub = [ones(n,1); inf*ones(S, 1); inf; ones(n,1)];
   lb = [zeros(n,1); zeros(S, 1); -inf; zeros(n,1)];
    
    % Define the inequality constraint matrices A and b
    A_turnover = [eye(n) zeros(n, S+1) -eye(n); -eye(n) zeros(n,S+1) -eye(n)];

    % Constraint 1:
    % -r11x1 - r12x2 - ... - r1nxn - z1 - gamma < 0
    % -r21x1 - r22x2 - ... - r2nxn - z2 - gamma < 0
    %                 .
    %                 .
    %                 .
    % -rS1x1 - rS2x2 - ... - rSnxn - zS - gamma < 0
    % Constraint 2:
    %  - mu1x1 - mu2x2 - ... - munxn < -R
    A = [-returns -eye(S) -ones(S, 1) zeros(S, n); -mu'  zeros(1,S) 0 zeros(1,n); A_turnover]; 
    b = [zeros(S, 1); -R; x_0; -x_0];
    
    
    
    % Define the equality constraint matrices A_eq and b_eq
    % x1 + x2 + ... + xn = 1
    Aeq = [ ones(1,n) zeros(1, S) 0 zeros(1,n)];
    beq = 1;
    
    % Define our objective linear cost function c
    
    % Coefficient on z terms
    k = (1/((1-alpha)*S));
    
    % There are no x terms in objective, sum of z terms and gamma
    c = [zeros(n,1); k*ones(S, 1); 1; lambda*ones(n,1)];
    
    % Set the linprog options to increase the solver tolerance
    options = optimoptions('linprog','TolFun',1e-9,'Display', 'off');

    % Use 'linprog' to find the optimal portfolio
    x = linprog( c, A, b, Aeq, beq, lb, ub, [], options );
    
    % Extract portfolio weights
    x = x(1:n);

end

