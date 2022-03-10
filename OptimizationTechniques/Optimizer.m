function [x] = Optimizer(mu, Q, returns, factRet, modelType, x0)
%OPTIMIZER Returns Appropriate optimization chosen
    config = ReadJson('config.json');
    
    if strcmp(config.opt_type, 'bear_bull_signal')
        use = modelType;
    else
        use = config.opt_type;
    end
    
    switch use
        case 'mvo'
            x = MVO(mu, Q, config.turnover_penalty, config.turnover_lambda);
        case 'sharpe_max'
            if config.sharpe_iter_sigma == 0
                x = SharpeMax(mu, Q, config.turnover_penalty, config.turnover_lambda, mean(mu), config.robust_ci, config.test_years);
                display(x)
            else
                x = SharpeMaxIter(mu, Q, config.turnover_penalty, config.turnover_lambda, config.sharpe_iter_sigma, config.robust_ci, config.test_years);
            end
        case 'cvar'
            x = CVarOpt(returns, factRet, config.cvar_alpha, Q, config.robust_ci, config.mc_stock_lb, config.mc_stock_ub);
        case 'risk_parity'
            x = RiskParity(Q, mu, config.mc_stock_lb, config.mc_stock_ub);
        case 'mc_port'
            x = MonteCarloPortfolio(mu, Q, config.mc_port_nPortfolios);
        case 'mc_stock'
            x = MonteCarloStock(mu, Q, config.mc_stock_nPaths, config.mc_stock_lb, config.mc_stock_ub);
        case 'mc_cvar'
            x = MonteCarloCVaR(mu, Q, returns, factRet, config.mc_stock_nPaths, config.cvar_alpha, config.robust_ci, config.mc_stock_lb, config.mc_stock_ub);
        case 'CVarOpt_Turnover'
            x = CVarOpt_Turnover(returns, factRet, config.cvar_alpha, x0);
    end
    
end
