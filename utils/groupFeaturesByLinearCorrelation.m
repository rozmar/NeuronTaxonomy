


function groups = groupFeaturesByLinearCorrelation(X)
  num = 1;
  idxes = [ 1:1:size(X,2) ];
  while size(X,2)>0
    if size(X(isnan(X(:,1)),:),1)==size(X,1)
      X(:,1) = [];
      idxes(1)=[];
      continue;
    end;
    c = corr( X(~isnan(X(:,1)),1) , X(~isnan(X(:,1)),:) )';
    idx = find(abs(c)>0.75);
    groups(num).idx = idxes(idx);
    num = num + 1;
    X(:,idx)=[];
    idxes(idx)=[];
    printf("Group %d, remained: %d\n", num, size(X,2));
    if isnan(c(1))
      printf("%f\n", X(:,1));
      return
    end

  end
end