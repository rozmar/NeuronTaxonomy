

function bestFeats = selectWithPCA(FV,indx)
	C=spearman(FV);
	[V l]=eig(C);
	[l i]=sort(diag(l),'descend');
	V=V(:,i);
	ratio = cumsum(l)/sum(l)
	%q = find(ratio<0.9,1,'last')
	q = 1;
	A_q=V(:,1:q);
	[idx,c,sumd,D]=kmeans(A_q,q);
	[m,i]=min(D)
	bestFeats=indx(i);
end