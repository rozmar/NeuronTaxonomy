function [fields M] = convertIVsToMatrix(ivs,whichfields,savepath)	
	M=[];
	fields=[];
	for i=1:size(fieldnames(ivs),1)
		currClassIV = ivs.(fieldnames(ivs)(i));
		for j=1:size(currClassIV,2)
			IV = currClassIV(1,j);
			row=[];
			for f=1:length(whichfields)
				fin = whichfields(f,1){1,1};
%				row = [row,IV.(fin)];
				if ~exist("submatrices","var")
					submatrices.(fin).mat = [];
					submatrices.(fin).num=0;
				elseif ~isfield(submatrices,fin)
					submatrices.(fin).mat = [];
					submatrices.(fin).num=0;
				end
				
				if submatrices.(fin).num < size(IV.(fin),2)
					submatrices.(fin).num = size(IV.(fin),2);
					if size(submatrices.(fin).mat,1) > 0
						submatrices.(fin).mat = growMatrix(submatrices.(fin).mat,size(submatrices.(fin).mat,1),size(IV.(fin),2));
					end
				end

				v = IV.(fin);
				if submatrices.(fin).num > size(IV.(fin),2)
					v = [v , repmat(0, 1, (submatrices.(fin).num-size(IV.(fin),2)))];
				end				
					
				submatrices.(fin).mat = [submatrices.(fin).mat ; v];
			end
			if ~isfield(submatrices,"label")
				submatrices.label.mat=[2-i];
			else
				submatrices.label.mat=[submatrices.label.mat ; 2-i];
			end
		end
	end
	
	for i=1:length(fieldnames(submatrices))
		fin = fieldnames(submatrices)(i){1,1};
		M = [M , submatrices.(fin).mat];
		fields = [fields ; fin];
		if strcmp("label",fin)==1
			submatrixSave.(fin).num = 2;	
		else
			submatrixSave.(fin).num= submatrices.(fin).num;
		end
		submatrixSave.(fin).mat = [];
	end
	
	save([savepath,"/submatrixStruct.mat"],"submatrixSave");
	return
end