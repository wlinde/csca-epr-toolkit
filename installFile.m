function [] = installFile(filename,directory,graphicsYes)
%% This function modifies a default NLSL.MOMD file to compile properly without graphics

    % Read a given file; Make a new string to house the modified output.
    
    
    if directory(end)~='/'
       directory=strcat(directory,'/');
    end
    
    text=fileread([directory,filename]);
    newfile='';
    
    % The original scripts used some percentage signs and backslashes
    % To print properly those must be doubled (% -> %%)
    text=strrep(text,'%','%%');
    text=strrep(text,'\','\\');
    
    % Split the newly-read file by line
    lines=strsplit(text,'\n');
    
    % Look for lines responsible for cpu time and comment them out. 
    % If the user selects graphicsYes==0, also remove lines that handle
    % plotting.
    i=1;
    while i<length(lines)+1
        % Graphics Part
        if strcmp(strtrim(lines{i}),'call wpoll')==1
            if graphicsYes==0
                newfile=strcat(newfile,'cc      Edited by Matlab Script Installer \ncc',lines{i},'\n');
                i=i+1;
            else
                newfile=strcat(newfile,lines{i},'\n');
                i=i+1;
            end
        elseif strcmp(strtrim(lines{i}),'pltx.o		: pltx.c fortrancall.h')==1
            if graphicsYes==0
                newfile=strcat(newfile,'#      Edited by Matlab Script Installer \n#',lines{i},'\n');
                i=i+1;
            else
                newfile=strcat(newfile,lines{i},'\n');
                i=i+1;
            end
        elseif strcmp(strtrim(lines{i}),'call shtwndws()')==1
            if graphicsYes==0
                newfile=strcat(newfile,'cc      Edited by Matlab Script Installer \ncc',lines{i},'\n');
                i=i+1;
            else
                newfile=strcat(newfile,lines{i},'\n');
                i=i+1;
            end
        elseif strcmp(strtrim(lines{i}),'NLSP = pltx.o')==1
            if graphicsYes==0
                newfile=strcat(newfile,'#      Edited by Matlab Script Installer \n#',lines{i},'\n NLSS = strutl.o lprmpt.o catch.o ipfind.o nlstxt.o \n');
                i=i+1;
            else
                newfile=strcat(newfile,lines{i},'\n');
                i=i+1;
            end
        elseif isempty(strfind(lines{i},'LIB'))==0
            if strcmp(lines{i}(1:3),'LIB')==1
                if graphicsYes==0
                    newfile=strcat(newfile,'#      Edited by Matlab Script Installer \n#',lines{i},'\n NLSS = strutl.o lprmpt.o catch.o ipfind.o nlstxt.o \n');
                    i=i+1;
                else
                    newfile=strcat(newfile,lines{i},'\n');
                    i=i+1;
                end
            else
                newfile=strcat(newfile,lines{i},'\n');
                i=i+1;
            end
        elseif strcmp(strtrim(lines{i}),'if (nspc.eq.nser) then')==1
            if graphicsYes==0
                if strcmp(filename,'datac.f')==1
                    pltLoopStart=i;
                    pltLoopEnd=pltLoopStart;
                    while strcmp(strtrim(lines{pltLoopEnd}),'end if')==0
                        pltLoopEnd=pltLoopEnd+1;
                    end
                    newfile=strcat(newfile,'cc      Edited by Matlab Script Installer \n');
                    for j=pltLoopStart:pltLoopEnd
                        newfile=strcat(newfile,'cc',lines{j},'\n');
                    end
                    i=pltLoopEnd+1;
                else
                    newfile=strcat(newfile,lines{i},'\n');
                    i=i+1;
                end
            else
                newfile=strcat(newfile,lines{i},'\n');
                i=i+1;
            end
        elseif strcmp(strtrim(lines{i}),'do i=1,nser')==1
            if graphicsYes==0
                if strcmp(filename,'lfun.f')==1
                    pltLoopStart=i;
                    pltLoopEnd=pltLoopStart;
                    while strcmp(strtrim(lines{pltLoopEnd}),'end do')==0
                        pltLoopEnd=pltLoopEnd+1;
                    end
                    newfile=strcat(newfile,'cc      Edited by Matlab Script Installer \n');
                    for j=pltLoopStart:pltLoopEnd
                        newfile=strcat(newfile,'cc',lines{j},'\n');
                    end
                    i=pltLoopEnd+1;
                else
                    newfile=strcat(newfile,lines{i},'\n');
                    i=i+1;
                end
            else
                newfile=strcat(newfile,lines{i},'\n');
                i=i+1;
            end
        % Broken CPU time part
        elseif strcmp(strtrim(lines{i}),'dtime.o         : dtime.c fortrancall.h')==1
            newfile=strcat(newfile,'#      Edited by Matlab Script Installer \n#',lines{i},'\n');
            i=i+1;
        elseif strcmp(strtrim(lines{i}),'cpu=dtime(tarray)')==1
            newfile=strcat(newfile,'cc      Edited by Matlab Script Installer \ncc',lines{i},'\n');
            i=i+1;
        elseif strcmp(strtrim(lines{i}),'NLSS = strutl.o lprmpt.o catch.o ipfind.o nlstxt.o dtime.o')==1
            newfile=strcat(newfile,'#      Edited by Matlab Script Installer \n#',lines{i},'\n NLSS = strutl.o lprmpt.o catch.o ipfind.o nlstxt.o \n');
            i=i+1;
        else
            newfile=strcat(newfile,lines{i},'\n');
            i=i+1;
        end
    end
    

    
    % Rewrite the target file and close it.
    fid=fopen(filename,'wt');
    fprintf(fid,newfile);
    fclose(fid);
    

end