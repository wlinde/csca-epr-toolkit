function[]=chSqPlot(out,clean,mult,showlocs,fignum)
    % Given a set of filenames, this function will plot the chi-squared
    % function for each 2-dimensional cross-section of the data. 
    
    % If user defines no chi^2 cutoff, use the maximum value
    if exist('mult','var')==0
        mult=max(clean.chiSq);
    end
    
    % clean up variable names to remove extraneous characters.
    params=out.intData(:,3:end);
    data=out.intData;
    varNames={out.intVarNames{3:end}};
    for i=1:length(varNames)
        varNames(i)={strtrim(strrep(varNames{i}, '-', ''))};        
    end
    
    % Sort raw chi^2 data to match order used for local minima.
    paramsCell=sortrows(horzcat(varNames',num2cell(params)'))';
    varNames=paramsCell(1,:);
    paramsCell(1,:)=[];
    params=cell2mat(paramsCell);
    parNames=varNames(3:end);

    % Fetch cluster positions, confidence intervals
    [meanVal,margMed,geoMed,medoid,interval]=clusterPosition(clean,mult,50,clean.limits);
    altpoints=[geoMed,medoid,margMed,meanVal];
     
    % Find local minima using stepwise data
    [pks,locs]=findpeaks(data(:,1));
    
    % Give bounds on parameters to be viewed
    fact=15*mult;
    limits=clean.limits;
    BoundschSq=data(:,2)<fact*min(data(:,2));
    dims=size(params);
    Bounds=zeros(dims(1),1);
    for i=1:dims(1)
        Bounds(i)= all(limits(1,:)<params(i,:) & params(i,:)<limits(2,:))*BoundschSq(i);
    end
    Bounds=find(Bounds>0);   
    
    
    % Give bounds on parameters to consider for clustering
    fact=mult;
    limits=clean.limits;
    locBoundschSq=data(:,2)<fact*min(data(:,2));
    dims=size(params);
    locBounds=zeros(dims(1),1);
    for i=1:dims(1)
        locBounds(i)= all(limits(1,:)<params(i,:) & params(i,:)<limits(2,:))*locBoundschSq(i);
    end
    locBounds=find(locBounds>0); 
    locsBounds=intersect(locBounds,locs);

    % Finally, plot the chi squared function within these bounds. 
    limitcell={};
    for i=1:length(clean.fitVarName)
        dummy=limits(:,i)';
        limitcell{i}=[dummy(1)-.1,dummy(2)+.1];
    end
    RLHeatScatterSP3varalt({params(Bounds,:)},{data(Bounds,2)},fignum,limitcell,varNames,{clean},{params(locsBounds,:)},{data(locsBounds,2)},altpoints,showlocs)


end