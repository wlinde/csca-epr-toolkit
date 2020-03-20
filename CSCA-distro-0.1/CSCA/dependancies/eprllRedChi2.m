function [redChiSq] = eprllRedChi2(params0,nameval,params)
    
    spltNameval=strsplit(nameval,'.');
    
    % Define 'newparams' structure, to accommodate changes without
    % overwriting the params structure
    newparams=params;

    % This function is designed to simply return the value of the spectrum
    % at the initial guess of the parameters. To do this, make the
    % nonlinear fit algorithm take at most one step in each case
    newparams.NLfit(fliplr(strcmp(params.NLfit,'maxit')))={1};  
    for i=1:newparams.numFit
        newparams.varyGuess{i,2}=params0(i);
    end

    % Run NLSL on each .run file, and write spectra to .out files
    % This function only uses one set of parameters.
    for i=1
        
        % Works on the 'dUmmy' file, saving experimental files under this
        % name
        nlslPwriteI('dUmmy',newparams,i,spltNameval{1});
        stringThing=strcat('cd ./',spltNameval{1},';\n',{newparams.path},{'/bin/nlsl '},{'<<LimitString\nread '},{' '},{'dUmmy'},{'_run'},{num2str(i)},{'.run'},{'\nexit\nLimitString'});
        cmd=sprintf(stringThing{1});
        %Suppress outputs of system-level commands to reduce demand.
        [~,~]=system(cmd);
        % Build names for the log files, and read their contents into a
        % text string
        namething=strcat('./',spltNameval{1},'/','dUmmy','_log',num2str(i),'.log');
        text=fileread(namething);
        % Sometimes log files are empty, due to a seg. fault. 
        % Anyways, this checks to make sure the file is non-empty
        

        % This tests to make sure that the spectral calculation converged; 
        % if the file contains the text 'did not converge', or if it is
        % completely empty, it modifies parameters slightly and restarts.
        % Sometimes the log file contains blank characters so these must be
        % disgarded by strtrim.
        while or(isempty(strfind(text,'did not converge'))~=1,isempty(strtrim(text))==1)

            % Works on the 'dUmmy' file, saving experimental files under this
            % name
            nlslPwriteI('dUmmy',newparams,i,spltNameval{1});
            stringThing=strcat('cd ./',spltNameval{1},';\n',{newparams.path},{'/bin/nlsl '},{'<<LimitString\nread '},{' '},{'dUmmy'},{'_run'},{num2str(i)},{'.run'},{'\nexit\nLimitString'});
            cmd=sprintf(stringThing{1});
            %Suppress outputs of system-level commands to reduce demand.
            [~,~]=system(cmd);
            % Build names for the log files, and read their contents into a
            % text string
            namething=strcat('./',spltNameval{1},'/','dUmmy','_log',num2str(i),'.log');
            text=fileread(namething);
            % Only change parameters if needed
            if not(or(isempty(strfind(text,'did not converge'))~=1,isempty(strtrim(text))==1))
                break
            end

            % Change parameters randomly by up to 0.005%
            params0=params0+rand(size(params0)).*params0/20000;
            newparams.NLfit(fliplr(strcmp(params.NLfit,'maxit')))={1};  
            for k=1:newparams.numFit
                newparams.varyGuess{k,2}=params0(k);
            end
        end

        % Clear console to reduce graphics demand on MatLab
        clc     

    end

    % Read intermediate data points into data matrix and collect
    % redChiSq (function output) (iff the file is non-empty)
    [intDdum,~]=logRead(namething);
    redChiSq=intDdum(1,2);
    
    close all



    cleanup(params,spltNameval,i);
end 
