function processExtractedIvs(listPath,listName,clabels)
	
	%load([listPath,'/path.mat'],'pathV');
  pathV = '/media/borde/Data/mdata';
  projectName = 'HumanAACBC';
  
	[cls id name ivname] = readInFileList(listPath,listName);
	for j=1:length(cls)
        clabel = clabels( cls(j) );
		fprintf('%s %s %s\n',id{j},name{j},ivname{j});
        rawDir = [pathV,'/',projectName],[name{j},'.mat'];
        
		doDataSum([pathV,'/',projectName],[name{j},'.mat'],[pathV,'/IV/',projectName,'/',clabel],id{j},pathV,'AM',ivname{j},clabel);
	end
end