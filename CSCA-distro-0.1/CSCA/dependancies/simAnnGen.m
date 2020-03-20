%This function generates successive iterations for the simulated annealing step.
function [newx]=simAnnGen(x,lb,ub)

    % We change one variable at a time, randomly, by a random increment of
    % no more than 0.01. 
    delta=(randperm(length(x))==length(x))*randn/100;
    
    % If that step is valid, add it to the previous and end function. If
    % that step is not valid, the -delta step is valid, and that is our new
    % step. 
    if and(prod(x+delta<ub)==1,prod(x+delta>lb)==1)
        newx=x+delta;
    else
        newx=x-delta;
    end
end