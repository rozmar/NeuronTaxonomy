%Normalize the data matrix.
%
%For all feature, subtract from every element the mean, then
%divide with  the stdev.
function norm = normalizeMatrixFromFile(mat,loadPath)

	load([loadPath,"/normalizing.mat"], "normalizing");

	meanv=normalizing.meanv;
	stdevv=normalizing.stdevv;

	norm=mat-repmat(meanv,size(mat,1),1);	%subtract the mean
	norm=norm./repmat(stdevv,size(mat,1),1);	%divide with stdev
	norm(isnan(norm))=0;
end
