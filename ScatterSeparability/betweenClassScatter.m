function S_b = betweenClassScatter(X,y,PI)
% Calculates the between class scatter. Larger between class variability means 
% more difference between clusters.
%
% X - instances, m*n, each row an instance, each column is a feature
% y - labels, m*1 matrix, contains the class labels/cluster id
% S_w - scalar, the within class scatter

  clusters = unique(y);	%ids of clusters/labels
  k = size(clusters,1);	%number of clusters/classes
  S_b = 0;
  
  M_o = nanmean(X);	%calculate the total sample mean by feature
    
  for i=1:k
    X_i = X(y==clusters(i),:);
    mu_i = nanmean(X_i);
    S_b_i = (mu_i-M_o)*(mu_i-M_o)';
    S_b = S_b + PI(i)*S_b_i;
  end

end