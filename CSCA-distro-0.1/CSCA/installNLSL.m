function [] = installNLSL(directory,graphicsYes)
    
    %% Function to clean NLSL files
    %  Instructions: Download your version of the NLSL (NLSL.MOMD
    %  recommended for most users) from ACERT: 
    %
    %       https://www.acert.cornell.edu/index_files/acert_ftp_links.php
    %  
    %  And extract it into the 'bin' directory of this software package.
    %  Then call this function to remove obselete references to CPU time
    %  (which are incompatible with many modern systems) and optionally to
    %  disable the graphics component of the NLSL program. We STRONGLY
    %  recommend disabling graphics, since this process will reduce fit
    %  speed and will make using the computer difficult during
    %  calculations. 
    %
    %  To run this software, make sure that this script is on the matlab
    %  path, simply call:
    %
    %               install('directory/name/here',0) %for no graphics
    %  or           install('directory/name/here',1) %to keep graphics
    %
    %  Then go to the install directory, make any necessary changes to the
    %  makefile, and compile NLSL.
    
    
    
    %  Get all the files in the directory, then run the installFile script
    %  on each, in order to comment out offensive lines of code. 
    files=dir(directory);
    
    if directory(end)~='/'
       directory=strcat(directory,'/');
    end
    
    for i=3:length(files)
        installFile([directory,files(i).name],graphicsYes);
        disp(files(i).name);
    end

end