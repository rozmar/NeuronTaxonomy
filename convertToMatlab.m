


function convertToMatlab(fpath)
	files=eval(["dir ",fpath]);
	for i=1:length(files)
		if files(i).isdir==0
			load([fpath,"/",files(i).name],"cellStruct");
			save("-mat-binary",[fpath,"/matlab/",files(i).name],"cellStruct");
		end
	end
end