function [fields M] = convertSingleIVtoVector(IV,whichfields,savepath, label)
	M=[];
	fields=[];
	row=[];
	submatrices = load([savepath,"/submatrixStruct.mat"]).submatrixSave;
	for f=1:length(whichfields)
		fin = whichfields(f,1){1,1};
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
		submatrices.label.mat=[double(label)];
	else
		submatrices.label.mat=[submatrices.label.mat ; double(label)];
	end
		
	for i=1:length(fieldnames(submatrices))
		fin = fieldnames(submatrices)(i){1,1};
		M = [M , submatrices.(fin).mat];	
		fields = [fields ; fin];
	end

	return
end