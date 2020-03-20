function [out,clean] = nlslDOS(nameval,params)
    % This locates the filepath associated with the nlsl matlab function
    % and passes it to the 'params' input. the program uses this path to
    % identify the directory containing the NLSL executable.
    
    p=mfilename('fullpath');
    params.path=fileparts(p);
    
    % Make directory for files
    spltNameval=strsplit(nameval,'.');
    if exist(spltNameval{1})~=7
        system(['mkdir ',spltNameval{1}]);
    end
    

    
    % Spline the data into a dummy file to avoid naming and data point
    % incompatibilities)
    copyfile(nameval,strcat('./',spltNameval{1},'/','dUmmy.dat'));
    inputDat=dlmread(nameval);
    if params.resType==0
        [xs,ys]=Spline512(inputDat(:,1),inputDat(:,2));
        fid=fopen(strcat('.\',spltNameval{1},'\','dUmmy.dat'),'w');
        for i=1:length(xs)
            fprintf(fid,'%f,%f\n',[xs(i),ys(i)]);
        end
        fclose(fid);
    end
    if params.resType==1
        [xres,yres]=Bootstrap(inputDat(:,1),inputDat(:,2),params.trialNum);
    end
    if params.resType==2
        [xres,yres]=MonteCarlo(inputDat(:,1),inputDat(:,2),params.trialNum,params.noise);
    end
   

    % We need to separately track the indices of acceptable data files (i.e.
    % data files which have converged, rather than failing to converge or
    % experiencing a segmentation fault. 

    trueind=1;
    Bfield=[];
    Idata=[];
    Ifit=[];
    intData=[];

    % Run NLSL on each .run file, and write spectra to .out files
    for i=1:params.trialNum
        
        if or(params.resType==1,params.resType==2)
            newdat=sortrows([xres(:,i),yres(:,i)],1);
            [xs,ys]=Spline512(newdat(:,1),newdat(:,2));
            fid=fopen(strcat('.\',spltNameval{1},'\','dUmmy.dat'),'w');
            for i=1:length(xs)
                fprintf(fid,'%f,%f\n',[xs(i),ys(i)]);
            end
            fclose(fid);
        end
        
        % Works on the 'dUmmy' file, saving experimental files under this
        % name
        nlslPwriteIDOS('dUmmy',params,i,spltNameval{1});
        
        stringThing=strcat({params.path},{'\bin\nlsl.exe '},{'< '},{'dUmmy'},{'_run'},{num2str(i)},{'.run'});
        
        cd(strcat('.\',spltNameval{1}));
        %Suppress outputs of system-level commands to reduce demand. 
        [~,~]=system(stringThing{1});
        numstring=strcat('ren dUmmy.spc dUmmy_out',num2str(i),'.out');
        [~,~]=system(numstring);
        cd ..
    

        % Build names for the log files, and read their contents into a
        % text string
        
        namething=strcat('.\',spltNameval{1},'\','dUmmy','_log',num2str(i),'.log');
        text=fileread(namething);
        
        % Sometimes log files are empty, due to a seg. fault. 
        % Anyways, this checks to make sure the file is non-empty
        if isempty(text)==0
            % This tests to make sure that the fit converged; if the file
            % contains the text 'did not converge', it discards these
            % results. 
            if isempty(strfind(text,'did not converge'))==1
                % Sometimes the program can't solve for the correlation
                % matrix, which is also bad:
                if isempty(strfind(text,'MINPACK could not find a solution'))==1
                    
                    % Read intermediate data points into data matrix
                    [intDdum,intVarNames]=logReadDOS(namething);
                    intData=[intData;intDdum];
                    
                    % Records index of good scans
                    goodInds(trueind)=i;
                    
                    % Course string splitting into lines
                    linesplit=strsplit(text,'\r\n');

                    % Finds lines useful for parameter identification
                    chsqLine=find(~cellfun(@isempty,strfind(linesplit,'Chi-squared=')));
                    finalLine=find(~cellfun(@isempty,strfind(linesplit,'*** Final Parameters ***')));
                    shiftLine=find(~cellfun(@isempty,strfind(linesplit,'Shifts')));

                    % Scrape the values of chi-squared and reduced chi-squared
                    dumsplit=strsplit(linesplit{chsqLine});
                    chiSq(trueind)=str2double(dumsplit{3});
                    redChiSq(trueind)=str2double(dumsplit{6});

                    % Scrape the values of fit parameters
                    for j=1:params.numFit
                        dumsplit=strsplit(linesplit{finalLine+2+j});
                        fit(trueind,j)=str2num(dumsplit{4});
                        fitVarName{j}=dumsplit{2};
                        uncertainty(trueind,j)=str2num(dumsplit{6});
                    end

                    % Scrape for the spectrum parameters
                    dumsplit=strsplit(linesplit{finalLine+2+params.numFit+1});
                    spec(trueind)=str2num(dumsplit{4});
                    specuncertainty(trueind)=str2num(dumsplit{6});

                    % Scrape for the B0(eff)
                    dumsplit=strsplit(linesplit{shiftLine+1});
                    B0(trueind)=str2num(dumsplit{end-1});
                    B0end(trueind)=str2num(dumsplit{end});

                    trueind=trueind+1;
                    
                    % Track the spectral fits           
                    outFiles=dir(strcat('.\',spltNameval{1},'\dUmmy_out',num2str(i),'.out'));
                    if isempty(fieldnames(outFiles))==0
                        data=dlmread(strcat('.\',spltNameval{1},'\',outFiles.name));
                        Bfield=[Bfield,data(:,1)];
                        Idata=[Idata,data(:,2)];
                        Ifit=[Ifit,data(:,3)];
                    end

                    % Clear console to reduce graphics demand on MatLab
                    clc
                    [num2str(round(i/params.trialNum*100)),'%']
                end
            end
        end
        close all
        

        
        if params.keepFiles==1
            % Rename output files to match original format
            logFiles=dir(strcat('.\',spltNameval{1},'\dUmmy_log',num2str(i),'.log'));
            runFiles=dir(strcat('.\',spltNameval{1},'\dUmmy_run',num2str(i),'.run'));
            outFiles=dir(strcat('.\',spltNameval{1},'\dUmmy_out',num2str(i),'.out'));
            
            % Only copy files which exist
            if isempty(outFiles) == 0
                if isempty(fieldnames(outFiles))==0
                    [~,~]=system(['ren .\',spltNameval{1},'\dUmmy_out',num2str(i),'.out .\',spltNameval{1},'\',spltNameval{1},outFiles.name(6:end)]);
                end
            end
            
            if isempty(fieldnames(runFiles))==0
                [~,~]=system(['ren .\',spltNameval{1},'\dUmmy_run',num2str(i),'.run .\',spltNameval{1},'\',spltNameval{1},runFiles.name(6:end)]);
            end
            
            if isempty(fieldnames(logFiles))==0
                [~,~]=system(['ren .\',spltNameval{1},'\dUmmy_log',num2str(i),'.log .\',spltNameval{1},'\',spltNameval{1},logFiles.name(6:end)]);
            end

        elseif params.keepFiles==0
            % Remove files
            [~,~]=system(['del .\',spltNameval{1},'\*.out']);
            [~,~]=system(['del .\',spltNameval{1},'\*.run']);
            [~,~]=system(['del .\',spltNameval{1},'\*.log']);
        end
    end
    
%%   This section collects data from output files

    % Transpose data when needed
    goodInds=goodInds';
    spec=spec';
    specuncertainty=specuncertainty';
    B0=B0';
    B0end=B0end';
    chiSq=chiSq';
    redChiSq=redChiSq';
    
    % Order fits by alphabetical variable name
    fits=fit;
    fits=sortrows(horzcat(fitVarName',num2cell(fits)'))';
    newVarName=fits(1,:);
    fits(1,:)=[];
    newFit=cell2mat(fits);
    
    % Order the limits appropriately, and ensure they correspond with
    % variable order. 
    oldLim=params.vary;
    oldLim=sortrows(oldLim);
    oldLim(:,1)=[];
    lims=cell2mat(oldLim)';

    % Write an output structure
    out.goodInds=goodInds;
    out.fit=newFit;
    out.uncertainty=uncertainty;
    out.spec=spec;
    out.specuncertainty=specuncertainty;
    out.B0=B0;
    out.B0end=B0end;
    out.chiSq=chiSq;
    out.redChiSq=redChiSq;
    out.fitVarName=newVarName;
    out.Bfield=Bfield;
    out.Idata=Idata;
    out.Ifit=Ifit;
    out.limits=lims;
    out.intVarNames=intVarNames;
    out.intData=intData;
    

    
    % This will remove all fits outside of the defined constraints.
    if not(and(params.parType==0,params.resType==0))
        clean=nlslResClean(out,params);
    end
    
    % If parType==2 or parType==3 we want the mean and variance associated with
    % the fits. If Type==0 or Type==1 these are not meaningful and hence
    % not reported. 
    if not(and(params.resType==0,params.parType==0))
        out.fitMean=mean(out.fit);
        out.fitVar=var(out.fit);
    end
    
    if and(params.resType==0,params.parType==0)
        save('nlslout','out','params')
    else
        save('nlslout','out','params','clean')
    end
    
    system(['move *.out ',spltNameval{1},'\; move *.log ',spltNameval{1},'\; move *.run ',spltNameval{1},'\; move *.mat ', spltNameval{1}, '\'])
    system(strcat('del .\',spltNameval{1},'\dUmmy.dat'));
    
end