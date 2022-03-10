function [B] = MarketBeta(returns, factRet)
%MARKETBETA Gets Market Beta for a list of stocks

    marketRet = factRet(:, 1);
    % Number of observations and factors
    [T, p] = size(marketRet); 
    
    % Data matrix
    X = [ones(T,1) marketRet];
    
    % Regression coefficients
    B = (X' * X) \ X' * returns;
    
    % Market Returns
    B = B(2, :);
end

