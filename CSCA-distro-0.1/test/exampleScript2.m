filenames={'test2345.dat','test3456.dat','test4567.dat'};

for i=1:length(filenames)
    % Generate Parameters
    cscaPmake2;
    % Run CSCA
    [out,clean]=nlsl(filenames{i},params);
end

for i=1:length(filenames)
 	% navigate to directories where output files are saved
 	cd(filenames{i}(1:end-4));
 
 	% load data
	 load('nlslout.mat');

 	% navigate back to test directory
 	cd ..

	% Plot
	chSqPlot(out,clean,2.5,2,i)
end