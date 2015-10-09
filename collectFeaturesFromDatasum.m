


function collectFeaturesFromDatasum(datasumInput,matrixOutput,clabel)
	dirs=dir(datasumInput);
	fileNum = 1;
	if nargin<3
		for i=1:length(dirs)
			if dirs(i).isdir && strcmp(dirs(i).name,'.')==0 && strcmp(dirs(i).name,'..')==0
                classDirName = strcat(datasumInput,'/',dirs(i).name);
				files = dir(classDirName);
				eval([dirs(i).name,'= [];']);
				for j=1:length(files)
					if  files(j).isdir
						continue;
					end
					fprintf('%s\n',files(j).name);
					[fRow fields] = loadDataSum(classDirName,files(j).name);
					fprintf('Datasum matrix: %d/%d\nNew datasum: %d\n',size([dirs(i).name,' ; ', num2str(fileNum)]), size(fRow,2));
					eval([dirs(i).name,'=[ ',dirs(i).name,' ; ', num2str(fileNum), ' fRow ];']);
					datasumMatrix.fileName{fileNum} = files(j).name;
					fileNum=fileNum+1;				
				end
				eval(['datasumMatrix.',dirs(i).name,'= ',dirs(i).name,';']);
			end
		end
		save([matrixOutput,'/datasumMatrix.mat'],'datasumMatrix');
	else
		
		classDirName = [datasumInput,'/',clabel];
		files = eval(['dir ',classDirName]);
		eval([clabel,'= [];']);
		for j=1:length(files)
			if  files(j).isdir
				continue;
			end
			printf('%s\n',files(j).name);
			[fRow fields] = loadDataSum(classDirName,files(j).name);
			eval([clabel,'=[ ',clabel,' ; ', num2str(fileNum), ' fRow ];']);
			datasumMatrix.fileName{fileNum} = files(j).name;
			fileNum=fileNum+1;					
		end
		eval(['datasumMatrix.',clabel,'= ',clabel,';']);

		save([matrixOutput,'/datasumMatrix',clabel,'.mat'],'datasumMatrix');		
	end
end
