


function centroids = getInitialCentroids(X,K) 
	%determine initial centroids
	maxVals = max(X);
	minVals = min(X);
	stepSize = (maxVals-minVals)./(K+1);
	centroids = repmat(minVals,K,1);
	for i=1:K
		centroids(i,:) = centroids(i,:).+(i.*stepSize);
	end	
end