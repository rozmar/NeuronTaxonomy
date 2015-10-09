function [trainset testset] = cutTestSet(dataset,i)
	positive = dataset(dataset(:,end)==1,:);
	negative = dataset(dataset(:,end)==0,:);	
	
	[pos90 pos10] = splitDataset1090(positive,i);
	[neg90 neg10] = splitDataset1090(negative,i);
	
	trainset = [pos90 ; neg90];		%current training set
	testset = [pos10 ; neg10];		%current (fully independent) test set, it's only used for evaluation
end