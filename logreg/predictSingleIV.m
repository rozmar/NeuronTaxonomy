function p =  predictSingleIV(IV,fieldpath,label,modelpath, modelname)
	

	[fields database] = convertSingleIVtoVector(IV,readFieldNames(fieldpath),fieldpath, label);
	normalize=load([fieldpath,"/normalizing.mat"]).normalizing;
	
	if size(database,2)~=size(normalize.meanv,2)
		printf("IV too long.\n")
		p = -1;
		return;
	end

	normalizedDataset = normalizeVector(database,normalize);
	
	th = load([modelpath,"/",modelname]).th;
	
	X = normalizedDataset(:,1:end-1);
	y = normalizedDataset(:,end);
	X = [1 X];
		
	p = int8(predict(th,X));
end