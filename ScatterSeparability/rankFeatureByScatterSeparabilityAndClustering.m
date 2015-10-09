function RS = rankFeatureByScatterSeparabilityAndClustering(X,l,list)

  d = size(X,2);	%dimension
    
  for k = 1 :  length(l)
    j = l(k);
    R = [];
    PM = makePermutation(d,j);
    fprintf('Calculating %d s\n',l(k));
    for i=1:size(PM,1)
      fprintf('%d/%d\n',i, size(PM,1));
      F = X(:,PM(i,:));
      
      if sum(isnan(F))==size(F,1)
        R = [ R ; double(list(PM(i,:))) 0 ];
        continue;
      end
      
      %F = removeOutliers(F,1);
      %F = removeFar10Procent(F);
      F = deleteoutliers(F);
    
      [idx,centroid] = kmeans(F,2,'emptyaction','singleton');

      SS = scatterSeparability(F,idx);
      
      R = [ R ; double(list(PM(i,:))) SS ];
    end
    R(isnan(R(:,2)),2)=0;
    [~,idx] = sort(R(:,end),'descend');
    R = R(idx,:);
    RS(j).R = R;
    %save('RS.mat','RS');
  end
end