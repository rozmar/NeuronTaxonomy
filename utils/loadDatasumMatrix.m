

function [shuffledData fields files] = loadDatasumMatrix(fpath)

	%load feature matrix and feature names
	load([fpath,"/datasumMatrix.mat"],"datasumMatrix");
	printf("Datasum loaded.\n");
	load([fpath,"/featureList.mat"],"featureList");
	fields = featureList;
	files = datasumMatrix.fileName;

	%labeling the positive matrix
	pos = [ datasumMatrix.A repmat(1,size(datasumMatrix.A,1),1) ];
	%labeling the negative matrix
	neg = [ datasumMatrix.B repmat(-1,size(datasumMatrix.B,1),1) ];
	%whole database
		
	database = [ pos ; neg ];
	normalizedDataset = normalizeMatrix(database,fpath);
	shuffledData = shuffleMatrix(normalizedDataset);

end
