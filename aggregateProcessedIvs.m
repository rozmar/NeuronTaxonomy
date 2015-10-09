function aggregateProcessedIvs(listPath,listName,inputDir,outputDir)
		
	label = listName(strfind(listName,"_")+1);
	[cls id name ivname] = readInFileList(listPath,listName);
	for j=1:length(cls)
		doDataSum([inputDir,"/",label],[name(j,:),".mat"],id{j},outputDir,"IVs",ivname(j,:),label);
	end
end