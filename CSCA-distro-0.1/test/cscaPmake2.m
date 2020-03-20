%% Use this file to generate EPR fit parameters
%  Follow the instructions in the comments below

        clearvars params

        % Set the number of fits to be conducted
        params.trialNum=100;
        
        % What type of optimization are you running? Do you want to:
        %       (0) Levenberg-Marquardt fit using a particular initial guess?
        %       (1) Levenberg-Marquardt fit using random initial guesses 
        %           within a range of values? (Monte Carlo LM search)
        %       (2) Levenberg-Marquardt fit using a rectangular 
        %           grid of points? (Grid LM Search)
        %       (3) Bounded Simulated Annealing.
        %       (4) Bounded Particle Swarm.
        %       (5) Bounded Genetic Algorithm.
        params.parType=2;

        % What type of data resampling analysis are you running? Do you want to:
        %       (0) No resampling
        %       (1) Monte Carlo from initial guess
        % Option (1) uses params.trialNum for the number of data resamplings.
        % Option (1) requires an estimate of noise.
        params.resType=0;
        params.noise=.001;

        % Do you want to keep NLSL output files?
        %       (0) No
        %       (1) Yes
        % The typical answer should be no
        params.keepFiles=0;

    %% Set constant parameters
    %  Select parameters to explicitly fix. Allowed variables are defined later
    %  in the script. These should have the form: {'variableName',value}. A
    %  separate cell array is used for floats and integers, respectively.

        params.fixfl={'gxx', 2.0095;
                       'gyy', 2.0067;
                       'gzz', 2.0027;
                       'aprp', 5.3;
                       'apll', 37.4;
                %        'b0',  3700;
                       };

        params.fixint={'lemx',  6;
                        'lomx',  5;
                        'kmx',   4;
                        'mmx',   4;
                        'ipnmx', 2;
                        'in2',   2;
                        'nort',  10;  % Set as 10, 20 or 50 for c20 fits
                        'nstep', 100;
                        };          

    %% Define parameters that vary
    %  Follow the instructions below. Do not vary more parameters than are
    %  necessary, as minima of chi^2 are exceedingly common. Note that only one
    %  of the two sections below will be used; ignore the other, as it will be
    %  deleted automatically based on your selected 'Type' value. 


        % For parType==O ; this goes unused in parType==1,2 fits. 
        %       Select parameters to vary, and assign a guess value. These should  
        %       have the form: {'variableName',guess}

        params.varyGuess={'rbar', 8.019;
%                            'n',    0.99; 
                           'c20',  0.042;
                           'gib0', 1.5
%                            'aprp', 9.5;
%                            'apll', 34;
                %            'bed', 0;
                            };

        % parType 1 or 2 fits select from within this range; chSq plot functions use these
        % as bounds. 
        %       Select parameters to vary, and assign upper and lower bounds.  
        %       These should have the form: {'variableName',lowerBound,upperBound}

        params.vary={'rbar', 6,        9;
%                       'n',    0.33,     3; 
                      'c20',  -5,    7;
                      'gib0', 0.001,      5;
%                       'aprp', 3,    14;
%                       'apll', 22.5,    38;
                %       'bed', 0, 90;
                      };

        

     