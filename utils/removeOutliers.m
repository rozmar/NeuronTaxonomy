function X = removeOutliers(X,radius)
  avgX = nanmean(X);
  stdX = nanstd(X);
  P = abs ( X - repmat(avgX,size(X,1),1) );
  stdX = repmat(radius*max(stdX),size(P));
  X(sum(P > stdX,2)>0,:)=[];	
end