function [O V] = backwardSearchBestCombinationFromClusters(X, bestFeatures, Clusters)
  TQ = [];
  NQ = [];
  for i=1:size(bestFeatures,2)
    V(i).V=[];
    O(i).O=[];	
  end
  
  TQ = [ TQ ; bestFeatures ];
  while size(TQ,1)>0
    f1 = TQ(1,:);
    TQ(1,:)=[];
    if notIn(V(size(f1,2)).V,f1)
      V(size(f1,2)).V = [ V(size(f1,2)).V ; f1 ];
    end
    possibleEdges = f1';
    for j=1:size(possibleEdges,1)
      f2 = setdiff(f1,possibleEdges(j));
      if moreDimensionIsBetterFromClusters(X,f1,f2,"mul",Clusters,bestFeatures)==1
        if notIn(V(size(f2,2)).V,f2)
          NQ = [ NQ ; f2 ];
          V(size(f2,2)).V = [ V(size(f2,2)).V ; f2 ];
        end
      elseif notIn(O(size(f2,2)).O,f2)
        O(size(f2,2)).O = [ O(size(f2,2)).O ; f2 ];
      end
    end
    if size(TQ,1)==0
      TQ=NQ;
      NQ = [];
    end
    if size(TQ,2)==1
      return;
    end
  end
end