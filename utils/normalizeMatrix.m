%Normalize the data matrix.
%
%For all feature, subtract from every element the mean, then
%divide with  the stdev.
function norm = normalizeMatrix(mat,savepath)
	meanv = nanmean(mat);	%calculate the mean of all features (except the label)
	stdevv = nanstd(mat);	%calculate the standard deviation of all features (except the label)
	
	meanv([1 end])=0;	%set back the label
	stdevv([1 end])=1;	%set back the label
	norm=mat-repmat(meanv,size(mat,1),1);	%subtract the mean
	norm=norm./repmat(stdevv,size(mat,1),1);	%divide with stdev
	norm(isnan(norm))=0;
	normalizing.meanv = meanv;
	normalizing.stdevv = stdevv;
	
	if nargin==2
		save([savepath,"/normalizing.mat"], "normalizing");
	end
end
