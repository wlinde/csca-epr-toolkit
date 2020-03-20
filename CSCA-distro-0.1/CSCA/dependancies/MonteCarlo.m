function [xres,yres]= MonteCarlo(xdata,ydata,number,noise)
        
    % Make x resample and y resample as LxN matrices, where L is the number
    % of data points and N is the number of resamplings. Output to the
    % original program. To put in a usable format, use:
    % dlmwrite('newtest.dat',sortrows([xres(:,1),yres(:,1)],1))
   
    % xres is the same column repeated
    % yres is sampled from a random distribution with the assumed noise. 
    
    xres=xdata.*ones(length(xdata),number);
    yres=normrnd(ydata.*ones(length(xdata),number),noise);
    
end