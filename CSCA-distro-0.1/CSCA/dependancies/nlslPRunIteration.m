function [intDatai,goodIndsi,chiSqi,redChiSqi,speci,specuncertaintyi,B0i,B0endi,Bfieldi,Idatai,Ifiti,trueindout,intVarNames,fiti,fitVarNamei,uncertaintyi] = nlslPRunIteration(spltNameval,params,i,trueind)
    
    % This function runs a single iteration of the 

    % Build names for the log files, and read their contents into a
    % text string

    namething=strcat('./',spltNameval{1},'/','dUmmy','_log',num2str(i),'.log');
    text=fileread(namething);
    
    % Pre-define output variables as empty so that if they don't get
    % defined, the function returns an empty matrix
    trueindout=trueind;
    intDatai=[];
    goodIndsi=[];
    chiSqi=[];
    redChiSqi=[];
    speci=[];
    specuncertaintyi=[];
    B0i=[];
    B0endi=[];
    Bfieldi=[];
    Idatai=[];
    Ifiti=[];
    intVarNames={};
    fiti=[];
    fitVarNamei={};
    uncertaintyi=[];
    

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
                [intDatai,intVarNames]=logRead(namething);

                % Records index of good scans
                goodIndsi=i;

                % Course string splitting into lines
                linesplit=strsplit(text,'\n');

                % Finds lines useful for parameter identification
                chsqLine=find(~cellfun(@isempty,strfind(linesplit,'Chi-squared=')));
                finalLine=find(~cellfun(@isempty,strfind(linesplit,'*** Final Parameters ***')));
                shiftLine=find(~cellfun(@isempty,strfind(linesplit,'Shifts')));

                % Scrape the values of chi-squared and reduced chi-squared
                dumsplit=strsplit(linesplit{chsqLine});
                chiSqi=str2double(dumsplit{3});
                redChiSqi=str2double(dumsplit{6});

                % Scrape the values of fit parameters
                for j=1:params.numFit
                    dumsplit=strsplit(linesplit{finalLine+2+j});
                    fiti(1,j)=str2num(dumsplit{4});
                    fitVarNamei{j}=dumsplit{2};
                    uncertaintyi(1,j)=str2num(dumsplit{6});
                end

                % Scrape for the spectrum parameters
                dumsplit=strsplit(linesplit{finalLine+2+params.numFit+1});
                speci=str2num(dumsplit{4});
                specuncertaintyi=str2num(dumsplit{6});

                % Scrape for the B0(eff)
                dumsplit=strsplit(linesplit{shiftLine+1});
                B0i=str2num(dumsplit{end-1});
                B0endi=str2num(dumsplit{end});
                
                % Advance the fit counter by 1. 
                trueindout=trueind+1;

                % Track the spectral fits           
                outFiles=dir(strcat('./',spltNameval{1},'/dUmmy_out',num2str(i),'.out'));
                if isempty(fieldnames(outFiles))==0
                    data=dlmread(strcat('./',spltNameval{1},'/',outFiles.name));
                    Bfieldi=[Bfieldi,data(:,1)];
                    Idatai=[Idatai,data(:,2)];
                    Ifiti=[Ifiti,data(:,3)];
                end

                % Clear console to reduce graphics demand on MatLab
                clc
                disp([num2str(round(i/params.trialNum*100)),'%']);
            end
        end
    end
    close all
    
    if params.keepFiles==1
        % Rename output files to match original format
        logFiles=dir(strcat('./',spltNameval{1},'/dUmmy_log',num2str(i),'.log'));
        runFiles=dir(strcat('./',spltNameval{1},'/dUmmy_run',num2str(i),'.run'));
        outFiles=dir(strcat('./',spltNameval{1},'/dUmmy_out',num2str(i),'.out'));

        % Only copy files which exist
        if isempty(outFiles) == 0
            if isempty(fieldnames(outFiles))==0
                [~,~]=system(['mv ./',spltNameval{1},'/dUmmy_out',num2str(i),'.out ./',spltNameval{1},'/',spltNameval{1},outFiles.name(6:end)]);
            end
        end

        if isempty(fieldnames(runFiles))==0
            [~,~]=system(['mv ./',spltNameval{1},'/dUmmy_run',num2str(i),'.run ./',spltNameval{1},'/',spltNameval{1},runFiles.name(6:end)]);
        end

        if isempty(fieldnames(logFiles))==0
            [~,~]=system(['mv ./',spltNameval{1},'/dUmmy_log',num2str(i),'.log ./',spltNameval{1},'/',spltNameval{1},logFiles.name(6:end)]);
        end

    elseif params.keepFiles==0
        % Remove files
        [~,~]=system(['rm ./',spltNameval{1},'/*.out']);
        [~,~]=system(['rm ./',spltNameval{1},'/*.run']);
        [~,~]=system(['rm ./',spltNameval{1},'/*.log']);
    end

end