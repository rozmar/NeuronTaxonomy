function R = rankFeatureByScatterSeparability(X,y,PI)
  
  d = size(X,2);	%dimension
  R = [];
  
  for i=1:d
    SS = scatterSeparability(X(:,i),y,PI);
    R = [ R ; i SS ];
  end
  
  R(isnan(R(:,2)),2)=0;
  [~,idx] = sort(R(:,2),'descend');
  R = R(idx,:);
end