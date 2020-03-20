% Function to create an regularly spaced rectangular grid over varNum
% dimensions and with a total of ~TrNum trials. The result is inexact
% because to preserve uniformity and grid size, TrNum^(1/varNum) must be an
% integer. However, if the user doesn't meet this criterion, the program
% finds the squarest-possible uniform grid and generates a matrix of
% normalized values suitable for arbitrary scaling.
function [nparams,newTrNum]=normGrid(varNum,TrNum)
    
    %  Generate ideal number of nodes in grid edge, and find the floor and
    %  ceiling of this value (lowN and hiN).
    optimalN=TrNum^(1/varNum);
    lowN=floor(optimalN);
    hiN=ceil(optimalN);
    
    %  Find integers j and k such that lowN^j*hiN^k is optimally close to
    %  TrNum.
    opts=zeros(varNum,1);
    for i=1:varNum+1
        j=varNum+1-i;
        opts(i)=lowN^j*hiN^(i-1);
    end
    noms=opts-TrNum;
    [minim,ind]=min(abs(noms));
    
    %  Create vector containing the number of nodes along each dimension. 
    npoints=[max(2,lowN)*ones(varNum-ind+1,1);hiN*ones(ind-1,1)];
    newTrNum=prod(npoints);
    
    %  Create the parameter matrix nparams systematically to find each
    %  point on the grid, and normalize points to edges of the unit rectangle
    %  between 0 and 1 on each dimension.
    nparams=zeros(prod(npoints),varNum);
    for i=1:length(npoints)
        dummy=[];
        for j=1:npoints(i)
            dummy=[dummy;ones(prod(npoints)/prod(npoints(1:i)),1)*(j-1)];
        end
        newcol=[];
        for j=1:prod(npoints)/prod(npoints(i:end))
            newcol=[newcol;dummy];
        end
        nparams(:,i)=newcol./(npoints(i)-1);
    end
    
    % Output nparams.
end