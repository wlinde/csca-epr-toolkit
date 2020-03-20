function []=cleanup(params,spltNameval,i)

    % If files are unnecessary, wipe them.

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

        if prod(size(runFiles))==0
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