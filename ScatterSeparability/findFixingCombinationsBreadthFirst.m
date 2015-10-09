
function O = findFixingCombinationsBreadthFirst(X, featureList)
  TQ = [];	%current Q 
  NQ = [];	%next Q
  for i=1:size(with,1)+1
    V(i).V=[];
    O(i).O=[];	
  end
  
  TQ = featureList';	%initial Q is the features
  while size(TQ,1)>0
    f1 = TQ(1,:);
    TQ(1,:)=[];
    V(size(f1,2)).V = [ V(size(f1,2)).V ; f1 ];
    possibleEdges = setdiff(featureList, f1)';
    M = zeros(10,size(possibleEdges,1));
    for i = 1 : 10 
      for j = 1 : size(possibleEdges,1)
        f2 = [f1 possibleEdges(j)];
        if moreDimensionIsBetter(X,f1,f2,'mul')==1
          M(i,j) = 1;
        end
      end
    end
    mM = mean(M);
    for j = 1 : size(possibleEdges,1)
        if mM(j)==1
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
  end
end
