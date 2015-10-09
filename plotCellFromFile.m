%
%
%
function plotCellFromFile(ivpath,cellfile,id,fname,cellname,imgodir,classLabel)
	
	if exist(ivpath)==0
		fprintf('Raw file %s doesnt exist.\n',ivpath);
		return
	end
	
	if exist(cellfile)==0
		fprintf('Datafile %s doesnt exist.\n',cellfile);
		return
    end
	
	iv=load(ivpath);
    iv = iv.iv;
		
	if isfield(iv,(strtrim(cellname)))==0
		fprintf('%s cell doesnt exist.\n', strtrim(cellname));
		return
    end
	
    
	iv=iv.(strtrim(cellname));
	cell=load(cellfile);
    cell=cell.cellStruct;
	
	disp(['Plotting ',cellfile]);
	
	plotIV(iv,cell,[id,' ',fname],cellname,0);
	%plotIVV0Vhyp(iv,cell,[id,' ',fname],cellname,0);
	%saveas(gcf,[fname,'_',cellname,'.png']);
	%print(gcf,[fname,'_',cellname,'.png']);
	saveas(gcf,[imgodir,'/',classLabel,'/',id,'_',fname,'_',cellname,'.png']);
	
end