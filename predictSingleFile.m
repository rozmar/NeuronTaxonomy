function predictSingleFile(fpath, name, ivname, label, modelpath, modelname,fieldpath)
	
	IV = loadIV(fpath,name,ivname);
	
	[fields database] = convertSingleIVtoVector(IV,readFieldNames(fieldpath),fieldpath, label);
	normalizedDataset = normalizeVector(database,fieldpath);
	
	
	th = load([modelpath,"/",modelname]).th
	
	X = normalizedDataset(:,1:end-1)
	y = normalizedDataset(:,end);
	X = [1 X];
	p = predict(th,X)
	int8(p)==y
end