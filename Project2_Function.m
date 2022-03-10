function x = Project2_Function(periodReturns, periodFactRet, x0)

    % Use this function to implement your algorithmic asset management
    % strategy. You can modify this function, but you must keep the inputs
    % and outputs consistent.
    %
    % INPUTS: periodReturns, periodFactRet, x0 (current portfolio weights)
    % OUTPUTS: x (optimal portfolio)
    %
    % An example of an MVO implementation with OLS regression is given
    % below. Please be sure to include comments in your code.
    %
    % *************** WRITE YOUR CODE HERE ***************
    %----------------------------------------------------------------------

    % Example: subset the data to consistently use the most recent 3 years
    % for parameter estimation
    addpath('MonteCarlo')
    addpath('OptimizationTechniques')
    addpath('Data')
    addpath('Util')
    addpath('FactorModels')
       
    % Read in Config Data
    config = ReadJson('config.json');
    
    years = config.test_years;
    % Convert to months
    T = floor(years*12);
    
    returns = periodReturns(end-T+1:end,:);
    factRet = periodFactRet(end-T+1:end,:);
    
    % Get data for specific time period
    % returns = periodReturns(1:1+12, :);
    % factRet = periodFactRet(1:1+12,:);
    
    % Example: Use an OLS regression to estimate mu and Q
    [mu, Q] = FactorModelSelector(returns, factRet);
    
    weights = linspace(1,2,12);
    state_rets = (factRet(end-12+1:end,1)+1)';
    weighted_geomean = prod(state_rets.^weights).^(1/sum(weights));

    if weighted_geomean > geomean(factRet(:,1)+1) % Bull state
        modelType = 'mc_stock';
    else % bear state
        modelType = 'risk_parity';
    end


    % Example: Use MVO to optimize our portfolio
    x = Optimizer(mu, Q, periodReturns, periodFactRet, modelType, x0);

    %----------------------------------------------------------------------
end
