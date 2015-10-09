function S_w = withinClassScatter(X,y,PI)
% Calculates the within class scatter.
%
% X - instances, m*n, each row an instance, each column is a feature
% y - labels, m*1 matrix, contains the class labels/cluster id
% S_w - scalar, the within class scatter

  clusters = unique(y);	%ids of clusters/labels
  k = size(unique(y));	%number of clusters/classes
  S_w = 0;

    
  for i=1:k
    X_i = X(y==clusters(i),:);
    if 1
      nans = zeros(size(X_i,1),1);
      for j = 1 : size(X_i,2) ; 
          nans = or(isnan(X_i(:,j)),nans);
      end
      X_i=X_i(~nans,:);
    else
      X_i = X_i(~isnan(X_i));
    end
    S_w_i = cov(X_i);
    S_w = S_w + PI(i)*S_w_i;
  end
	
	
end