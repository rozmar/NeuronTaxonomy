

function selectNMissingFeatures(confmat, featList, n, NX)
	featMiss=find(sum(confmat(:,2:3),2)==n);
	for i=1:length(featMiss)
		c=corr(NX(:,119),NX(:,featMiss(i)+1));
		if 1-abs(c)>0.2
			printf("%d %s %f\n", featMiss(i), featList{featMiss(i)},c);
		end
	end
end