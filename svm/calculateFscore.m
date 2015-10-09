


function fscore = calculateFscore(F,y)
	avg = nanmean(F);
	
	pNum = size(y(y==1),1);
	nNum = size(y(y==-1),1);
	
	pF = F(y==1);
	nF = F(y==-1);
	
	pos_avg = nanmean(pF);
	neg_avg = nanmean(nF);
	
	numerator = pNum*(pos_avg-avg)^2 + nNum*(neg_avg-avg)^2;
	
	denominator = sum(pF.^2)-((sum(pF)^2)/pNum) + sum(nF.^2)-((sum(nF)^2)/nNum);
	
	if denominator==0
		denominator=1e-12;
	end
	
	fscore = numerator / denominator;
end