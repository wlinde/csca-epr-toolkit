cscaPmake
nlsl('test1234.dat',params);
cd test1234
load('nlslout.mat');
cd ..
chSqPlot(out,clean,2.5,2,13);
[meanVal,margMed,geoMed,medoid,interval]=clusterPosition(clean,2.5,50,clean.limits);

