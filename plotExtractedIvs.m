


function plotExtractedIvs(listPath,listName,ivinputDir,featinputDir,imgodir,clabels)

	[cls id name ivname] = readInFileList(listPath,listName);
	
    cls(cls==0)=3;

    projectName = 'HumanAACBC';
    
	for j=1:length(cls)
        clabel=clabels(cls(j));
        ivpath = [ivinputDir,'/',projectName,'/',name{j},'.mat'];
        cellfile = [featinputDir,'/',projectName,'/',clabel,'/data_iv_',id{j},'_',name{j},'.mat_',strtrim(ivname{j}),'.mat'];
        imgoutputdir = [imgodir,'/',projectName,'/',clabel];
		plotCellFromFile(ivpath,cellfile,id{j},name{j},strtrim(ivname{j}),imgoutputdir,clabel);
		%plotCellFromFile([ivinputDir,'/',name(j,:),'.mat'],[featinputDir,'/data_iv_',id{j},'_',[name(j,:),'.mat'],'_',strtrim(ivname(j,:)),'.mat'],id{j},name(j,:),strtrim(ivname(j,:)),imgodir,classLabel);
		
	end
end