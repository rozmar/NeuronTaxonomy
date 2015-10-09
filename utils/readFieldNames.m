%Read selected field names from file.
%
%It is used before converting IV data to matrix,
%this fields will specify the matrix columns.
%This file contains relevant fields selected by hand
%or by feature selection algorithm.
function list = readFieldNames(fpath)
	file = [fpath,"/fnamesToUse.txt"];	%absolute file name
	f=fopen(file,"r");		%open file
	list = textread(file,"%s");	%read field names
	fclose(f);
	return;	
end