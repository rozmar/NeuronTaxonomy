
load('/home/sborde/mdata/datasum/FNX_posramp.mat');	%load feature matrix
load('/home/sborde/mdata/datasum/bestFeatures.mat');	%load filtered features
load('/home/sborde/mdata/datasum/procMatrix_posramp.mat'); %load all data

Leaves = backwardSearchBestCombinationNotStrict(FNX,bestFeatures,100,'on');

save('Leaves_20140521_02.mat','Leaves');

