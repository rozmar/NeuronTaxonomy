


function better = moreDimensionIsBetterFromClusters(X,i,j,type,Clusters,bestFeatures)
  F1 = X(:,i);
  F2 = X(:,j);
  for i1 = 1 : length(Clusters(length(i)).Index)
    f1 = bestFeatures(Clusters(length(i)).Index(i1).features)';
    if mean(sort(f1) == sort(i))==1
      idx1 = Clusters(length(i)).Index(i1).idx;
      break;
    end
  end
  for i2 = 1 : length(Clusters(length(j)).Index)
    f2 = bestFeatures(Clusters(length(j)).Index(i2).features)';
    if mean(sort(f2) == sort(j))==1
      idx2 = Clusters(length(j)).Index(i2).idx;
      break;
    end
  end  
  if idx1(1)==2 ;
    idx1 = repmat(3,size(idx1,1),1)-idx1;
  end
  if idx2(1)==2 ;
    idx2 = repmat(3,size(idx1,1),1)-idx2;
  end    
  CRITF1C1 = scatterSeparability(F1,idx1,[sum(idx1==1),sum(idx1==2)]./length(idx1));
  CRITF2C2 = scatterSeparability(F2,idx2,[sum(idx2==1),sum(idx2==2)]./length(idx2));
  CRITF1C2 = scatterSeparability(F1,idx2,[sum(idx2==1),sum(idx2==2)]./length(idx2));
  CRITF2C1 = scatterSeparability(F2,idx1,[sum(idx1==1),sum(idx1==2)]./length(idx1));
  if strcmp(type,'mul')==1
    NF1C1 = CRITF1C1 * CRITF2C1;
    NF2C2 = CRITF2C2 * CRITF1C2;
  elseif strcmp(type,'add')==1
    NF1C1 = CRITF1C1 + CRITF2C1;
    NF2C2 = CRITF2C2 + CRITF1C2;
  elseif strcmp(type,'penalty')==1
    NF1C1 = CRITF1C1 / size(i,2);
    NF2C2 = CRITF2C2 / size(j,2);
  end
  better = NF2C2>=NF1C1;
end