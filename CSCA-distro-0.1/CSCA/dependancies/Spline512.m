% If users don't specifically spline their data, this does. 
function [splx,sply] = Spline512(x0,y0)

    % Get the important region
    xlimits=[min(x0),max(x0)];
    indices=find(x0>min(xlimits) & x0<max(xlimits));
    
    % This function eliminates repeated points by using the average value
    [x00,~,idx]=unique(x0,'stable');
    y00=accumarray(idx,y0,[],@mean);
    splx=[xlimits(1):(xlimits(2)-xlimits(1))/512:xlimits(2)]';
    
    
    % Spline onto the given x values
    sply=interp1(x00,y00,splx);   
    splx=splx(2:end);
    sply=sply(2:end);
%     Removed 6/7/2017 to fix weird spline error. 
%     sply=spline(x00,y00,splx);   
end