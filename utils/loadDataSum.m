function [ featureRow  fields ] = loadDataSum(filepath,filename)
	load([filepath,'/',filename]);
    ds = datasum;
	featureRow = [];
	fields = fieldnames(ds);
	for i=1:length(fieldnames(ds))
        fieldname = fieldnames(ds);
        fieldname = fieldname{i};
        if size(ds.(fieldname),1)==0 
          ds.(fieldnames) = NaN;
        end
		featureRow = [ featureRow ds.(fieldname) ];
	end
end