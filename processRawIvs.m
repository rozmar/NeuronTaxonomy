function processRawIvs(listPath,listName,inputDir,outputDir,projectName, clabels)
%PROCESSRAWIVS processes raw measurement IV-s and extracts the electrophysiological features from them.
%
%PROCESSRAWIVS(listPath,listName,inputDir,outputDir,projectName, clabels) 
%Parameters:
% - listPath: directory path where the input list and the name of features
% have been placed
% - listName: name of the input list
% - inputDir: in which directory are the input raw IV files
% - outputDir: where to save the extracted features
% - projectName: name of the project. It will be the name of the
% subdirectory of the extracted feature files in the ouputDir directory
% - clabels: if given, the extracted files will be grouped in separate
% directories. Which files belongs to which class is determined from
% inputList
%
% Input list format: 
% label id fname g s c
% (label - starts from 1)
% Example:
% 1 ID1 140322rm 1 2 3
	
	[cls, id, name, ivname] = readInFileList(listPath,listName);
	for j=1:size(cls,1)
        
        if nargin<6 
            classDir = '/';
        elseif length(clabels)<=1
            classDir = '/';
        else
            classDir = ['/',clabels(cls(j))];
        end
        if strcmp(class(inputDir),'char')
            processCellFromFile(inputDir,[name{j},'.mat'],id{j},outputDir,[projectName,classDir],ivname{j},listPath);
        else
            processCellFromFile(inputDir{j},[name{j},'.mat'],id{j},outputDir,[projectName,classDir],ivname{j},listPath);
        end
		
        drawnow('update');
	end
end
