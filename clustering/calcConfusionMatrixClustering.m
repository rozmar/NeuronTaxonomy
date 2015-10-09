


function confmat = calcConfusionMatrixClustering(X,idx,y)
	y2 = y;             %predicted labeling
	posCent = 1;		%positive label centroid
	negCent = 0;        %negative label centroid
	predictedPos = find(idx==posCent);	%get samples from positive centroid
	predictedNeg = find(idx==negCent);
	if size(predictedPos,1)>0
	  realLabel = y(predictedPos);	%get real label from positive centroid
 	  y2(predictedPos) = mode(realLabel);
 	end
	if size(predictedNeg,1)>0 	
	  realLabel2 = y(predictedNeg);
	  y2(predictedNeg) = mode(realLabel2);
	end
	
	tp = size(intersect(find(y==1),find(y2==1)),1);
	tn = size(intersect(find(y==0),find(y2==0)),1);
	fp = size(intersect(find(y==0),find(y2==1)),1);
	fn = size(intersect(find(y==1),find(y2==0)),1);
	
	confmat = [ tp fp fn tn ];
end