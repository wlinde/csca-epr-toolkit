function[meanVal,margMed,geoMed,medoid,interval]=clusterPosition(clean,mult,confInt,limits)
    % the confInt input is supposed to be a percentage (e.g. 50%). Limits
    % should have the form observable in clean.limits
    
    closeIshchSq=clean.redChiSq<mult*min(clean.redChiSq);
    dims=size(clean.fit);
    closeIsh=zeros(dims(1),1);
    for i=1:dims(1)
        closeIsh(i)= all(limits(1,:)<clean.fit(i,:) & clean.fit(i,:)<limits(2,:))*closeIshchSq(i);
    end
    closeIsh=find(closeIsh>0);    
    
    % Geometric median computed using program by Daniel Zhang, included in
    % opt_tools folder
    geoMed=geometric_median(clean.fit(closeIsh,:)');
    
    % Medoid computed using kmedoids tool in MatLab, performed for 1
    % cluster. 
    [~,medoid]=kmedoids(clean.fit(closeIsh,:),1);
    medoid=medoid';
    
    % Mean
    if length(clean.fit(closeIsh))<2
        error('Your fit constraints were too strict, and your observed cluster does not contain multiple fits. Try rerunning with a higher mult val.')
    end
    
    meanVal=mean(clean.fit(closeIsh,:))';
    
    %

    
    % Convert confidence interval to 5mg2p3-10ulPF-T275-302-att15-T299fraction, and compute interval
    % endpoints and median value.
    confInt=confInt/100;
    percentiles=[0.5-confInt/2,0.5,0.5+confInt/2];
    for j=1:3
        percents(:,j)=prctile(clean.fit(closeIsh,:),percentiles(j)*100)';
    end
    margMed=percents(:,2);
    interval=[percents(:,1),percents(:,3)];
    
    
end


