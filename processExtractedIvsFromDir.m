function processExtractedIvsFromDir(ivinputDir,featinputDir,outputDir,clabel)

	if nargin == 4
		clabel = ['/',clabel];
	else
		clabel = '';
	end			

	files=dir([featinputDir,clabel]);
	
	for i = 1 : length(files) ; 
	  if strcmp(files(i).name,'.') || strcmp(files(i).name,'..')
	    continue;
	  end
	  fname = files(i).name;
	  parts = strsplit(fname,'_');
    if length(parts)==7
	    id = parts{3};
	    ivname = parts{4};
	    cellname = [parts{5},'_',parts{6},'_',parts{7}(1:findstr(parts{7},'.')-1)];
    else
	    id = strcat(parts{3},'_',parts{4});
	    ivname = parts{5};
	    cellname = [parts{6},'_',parts{7},'_',parts{8}(1:findstr(parts{8},'.')-1)];
    end
	  doDataSum(ivinputDir,ivname,[featinputDir,clabel],fname,id,[outputDir,clabel],cellname)
	  disp(['Processed ',fname]);
	end
end