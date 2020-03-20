function [xres,yres]= Bootstrap(xdata,ydata,number)
      
    % Resample data into random bins
    resamp=rand(length(xdata),number);
    edges=0:1/length(xdata):1;
    bins=discretize(resamp,edges);
    
    % Make x resample and y resample as LxN matrices, where L is the number
    % of data points and N is the number of resamplings. Output to the
    % original program. To put in a usable format, use:
    % dlmwrite('newtest.dat',sortrows([xres(:,1),yres(:,1)],1))

    xres=xdata(bins);
    yres=ydata(bins);
    
end