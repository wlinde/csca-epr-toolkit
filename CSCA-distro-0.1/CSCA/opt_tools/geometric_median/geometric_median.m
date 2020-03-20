function gm = geometric_median(X)
% From https://www.mathworks.com/matlabcentral/fileexchange/70145-medoid-and-geometric-median
% Calculate geometric median
%
% Input:
%   X: d x n data matrix
%
% Output:
%   gm: the geometric median
%
% Written by Detang Zhong (detang.zhong@canada.ca).
%
u = @(m)trace((m'*m).^.5); 
f=@(m)fminsearch(@(y)u(bsxfun(@minus,m,y)),m(:,1));
gm = f(X);
end