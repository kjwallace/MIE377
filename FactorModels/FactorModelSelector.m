function [mu, Q] = FactorModelSelector(returns, factRet)
%FACTORMODELSELECTOR Summary of this function goes here
    config = ReadJson('config.json');
    
    switch config.factor_type
        case 'ols'
            [mu, Q] = OLS(returns, factRet);
        case 'stepwise'
            [mu, Q] = StepwiseRegression(returns, factRet);
    end
end
