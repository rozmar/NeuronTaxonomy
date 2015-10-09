% Calculates the error of the clustering.
%
% In parameter expect the centroids, the datapoints
% and datapoint-centroid assignments.
function J = kMeansCostFunction(centroids, X, idx)
	m = size(X,1);	%number of examples
	K = size(centroid,1);
	J = 0;
	
	%loop through centroids
	for i=1:K
		X_i=X(find(idx==i),:);	%get datapoints assigned to ith centroid
		c = centroids(i,:);	%current centroid
		
		J = J + sum((sum((repmat(c,size(X_i,1),1).-X_i).^2,2)).^(1/2));
	end
end

