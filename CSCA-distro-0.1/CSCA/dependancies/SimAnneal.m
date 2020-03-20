function [xopt] = SimAnneal(nameval,params)
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
        fid=fopen(strcat('./',spltNameval{1},'/','dUmmy.dat'),'w');
        for i=1:length(xs)
            fprintf(fid,'%f,%f\n',[xs(i),ys(i)]);
        end
        fclose(fid);
    else
        error('resType must be 0 for this function')
    end

    % Define an anonymous function for eprllRedChi2
    objectiveFunction=@(params0) eprllRedChi2(params0,nameval,params);
    % Call the simulated annealing function, using the supplied initial
    % guess as a starting point.
    xopt=simulannealbnd(objectiveFunction,[params.varyGuess{:,2}],[params.vary{:,2}],[params.vary{:,3}]);
%     xopt=anneal(objectiveFunction,[params.varyGuess{:,2}]);




end