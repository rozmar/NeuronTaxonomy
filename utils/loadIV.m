%Loads a specified IV features from a 
%given datasum.
%
%Parameters:
% fpath - path of the datasum
% file - name of the file
% ivname - name of the iv
function iv = loadIV(fpath,file,ivname)
	fil = load([fpath,"/datasum_",file,".mat"]);	%load file
	cell = fil.("datasum").(["elfiz",file]);		%select IV
	if ~isfield(cell.(ivname),"pathandfname") 	%if pathandfname missing, correct it
		cell.(ivname).("pathandfname"){1,1} = "../mdata/IV/IVs";
		cell.(ivname).("pathandfname"){1,2} = ["/data_iv_",file,".mat"];
	end
	iv = cell.(ivname);			%select the specified IV from cell
end