function [] = nlslPwriteI(name,params,I,dirname)

    % This program generates .run files for input into the NLSL program.It
    % takes as its inputs: 'name' is a filename for a Bruker instrument; 
    % 'params' is a structure created by nlslPmake. 
 
  

    varsize=size(params.varyGuess);

    % The parameters to vary need a bit of fixing to work with this program
    for i=1:varsize(1)-1
        newvary{i}=[' ',params.varyGuess{i,1},','];
    end
    newvary{varsize(1)}=[' ',params.varyGuess{end,1}];
    
    % As do the convergence criteria
    for i=1:4
        nlcon{i}=[' ',params.NLfit{i,1},' ',num2str(params.NLfit{i,2})];
    end
    
    
    % Next we write the run files
    for trial=I
        
        % Create a file 'name_runx.run'
        fid = fopen(strcat('./',dirname,'/',name,'_run',num2str(trial),'.run'), 'w');
        if fid == -1 
            error('Cannot open file: %s', outfile) 
        end
        
        % Opens log file 'name_logx.log' for this session:
        fprintf(fid,'echo --- Opens log file for this session \n');
        fprintf(fid,'\n');
        fprintf(fid,'%s %s%s%i \n \n','log',name,'_log',trial);
        
        % Prints file information into log file
        fprintf(fid,'echo off \n \n');
        fprintf(fid,'echo \n');
        fprintf(fid,'echo ********************************************************************** \n');
        fprintf(fid,strcat('echo \t \tNLSL run file for \t',name,'.dat \n'));
        fprintf(fid,'echo \t \t \t %s \t %i %s %i \n','Trial Number:',trial,'of',params.trialNum);
        fprintf(fid,'echo ********************************************************************** \n');
        fprintf(fid,'echo \n \n');
        
        % For each variable, the script generates the following text:
        %           let 'variable' = value
        % For fixed integers:
        for i=1:length(params.fixint)
            fprintf(fid,'%s %s %s %i \n','let',params.fixint{i,1},'=',params.fixint{i,2});
        end
        
        % For fixed floats:
        for i=1:length(params.fixfl)
            fprintf(fid,'%s %s %s %d \n','let',params.fixfl{i,1},'=',params.fixfl{i,2});
        end
        
        % For variable floats
        for i=1:varsize(1)
            fprintf(fid,'%s %s %s %d \n','let',params.varyGuess{i,1},'=',params.varyGuess{i,1+trial});
        end
        
        % Print a blank line
        fprintf(fid,'\n');
        
        %Smooths data:
        fprintf(fid,'echo --- Read in ASCII datafile \n');
        fprintf(fid,'echo ---    (1) Spline interpolate the data to 200 points \n');
        fprintf(fid,'echo ---    (2) baseline-correct by fitting a line to 20 points at each end \n');
        fprintf(fid,'echo ---    (3) allow shifting of B0 to maximize overlap with data \n');
        fprintf(fid,'\n');
        fprintf(fid,'%s %s %s \n \n','data',name,'ascii nspline 200 bc 20 shift');

        %Specify parameters to vary:
        fprintf(fid,'echo --- Specify parameters to vary \n');
        fprintf(fid,'echo \n \n');
        fprintf(fid,'%s%s \n \n','vary',strcat(newvary{1:end}));  

        %Run the fit:
        fprintf(fid,'echo --- Carry out nonlinear least-squares procedure: \n');
        fprintf(fid,'echo ---    (1) Stop after a maximum of, maxit iterations \n');
        fprintf(fid,'echo ---    (2) Stop after a maximum of maxfun spectral calculations \n');
        fprintf(fid,'echo ---    (3) Chi-squared convergence tolerance is 1 part in ftol \n');
        fprintf(fid,'echo \n \n');
        fprintf(fid,'%s%s \n \n','fit',strcat(nlcon{1:end}));  
    end
    fclose(fid);
end