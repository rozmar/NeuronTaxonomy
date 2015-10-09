% Runs a K-means clustering on the given datapoints with given centroid number.
%
% In parameter expect the data and the number of clusters.
function centroids = runClustering(X,K,y)
	dim = size(X,2);
	m = size(X,1);
	iter = 1;
	centroids = getInitialCentroids(X,K);
	
	%plot2DCluster(X,centroids);
	
	lastCentroid = zeros(K,dim);
	while sum(sum(lastCentroid==centroids))~=(size(centroids,1)*size(centroids,2))
	%	printf("%d. iteration\n",iter);
		lastCentroid = centroids;
		idx = findClosestCentroids(X, centroids);
		if nargin==3
			%plot2DCluster(X,centroids,idx,"off",y);
		else
			%plot2DCluster(X,centroids,idx,"off");
		end
		%saveas(gcf,["movie/",num2str(iter),".png"]);
		centroids = computeCentroids(X, idx, K);
		iter++;
		if mod(iter,100)==0
			printf("Iteration %d\n",iter);
		end
		if iter>1000
			printf("Iteration aborted.\n");
			break
		end
	end	
end