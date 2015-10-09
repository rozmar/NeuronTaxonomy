
function plotExtractedIvsFromDir(ivinputDir,featinputDir,imgodir,clab)

	if nargin == 4
		clab = ['/',clab];
	else
		clab = '';
    end			

    idir = [featinputDir,clab];
	files=dir(idir);
	
	for i = 1 : length(files) ; 
	  if strcmp(files(i).name,'.') || strcmp(files(i).name,'..')
	    continue;
	  end
	  fname = files(i).name;
	  parts = strsplit(fname,'_');
	  id = parts{3};
	  ivname = parts{4};
	  cellname = [parts{5},'_',parts{6},'_',parts{7}(1:strfind(parts{7},'.')-1)];
	  plotCellFromFile([ivinputDir,'/',ivname],[featinputDir,clab,'/',fname],id,fname(1:strfind(fname,'.')-1),cellname,imgodir,clab);
	  disp(['Plotted ',fname]);
	end
end