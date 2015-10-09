%Normalize the data matrix.
%
%For all feature, subtract from every element the mean, then
%divide with  the stdev.
function norm = normalizeVector(vec,normalize)
	meanv = normalize.meanv;	%calculate the mean of all features (except the label)
	stdevv = normalize.stdevv;	%calculate the standard deviation of all features (except the label)
	norm=vec-repmat(meanv,size(vec,1),1);	%subtract the mean
	norm=norm./repmat(stdevv,size(vec,1),1);	%divide with stdev
	norm(isnan(norm))=0;
end