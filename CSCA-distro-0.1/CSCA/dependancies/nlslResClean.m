function [clean] = nlslResClean(out,params)
    
    % A subroutine to prune away fits outside the constraint rectangle. 

    % This only makes sense for constrained fits. 
    if not(and(params.resType==0,params.parType==0))
        % Order fits by alphabetical variable name
        fits=out.fit;
        fits=sortrows(horzcat(out.fitVarName',num2cell(fits)'))';
        varNames=fits(1,:);
        fits(1,:)=[];
        fits=cell2mat(fits);

        % Order limits by alphabetical variable name
        limits = sortrows(params.vary);
        limits = cell2mat(limits(:,2:3));

        % Count how many variables there are (how many columns)
        [m,fitCols]=size(fits);

        % Replace all values outside of the vary limits with NaN
        for colNum=1:fitCols
            temp=fits(:,colNum);
            temp(temp<=limits(colNum,1) | temp>=limits(colNum,2)) = NaN;
            fits(:,colNum)=temp;
        end

        % Re-create an array similar to fit data but with NaN
        filteredOut=horzcat(out.goodInds,fits,out.uncertainty,out.spec,out.specuncertainty,out.B0,out.B0end,out.chiSq,out.redChiSq);

        % Remove all rows containing NaN
        filteredOut(any(isnan(filteredOut')),:) = [];

        % Build the clean structure
        clean = struct('goodInds',filteredOut(:,1),'fit',filteredOut(:,2:1+fitCols),'uncertainty',filteredOut(:,2+fitCols:1+2*fitCols),'spec',filteredOut(:,2+2*fitCols),'specuncertainty',filteredOut(:,3+2*fitCols),'B0',filteredOut(:,4+2*fitCols),'B0end',filteredOut(:,5+2*fitCols),'chiSq',filteredOut(:,6+2*fitCols),'redChiSq',filteredOut(:,7+2*fitCols));
        clean.fitVarName=varNames;
        
        % Grab the associated spectral data
        logicals=ismember(out.goodInds,clean.goodInds);
        Bfield=[];
        Idata=[];
        Ifit=[];

        for i=1:length(logicals)
            if logicals(i)==1
                Bfield=[Bfield,out.Bfield(:,i)];
                Idata=[Idata,out.Idata(:,i)];
                Ifit=[Ifit,out.Ifit(:,i)];
            end
        end
        
        clean.Bfield=Bfield;
        clean.Idata=Idata;
        clean.Ifit=Ifit;
        clean.limits=out.limits;

    else
        clean=struct();
    end
end