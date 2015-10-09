


function tree = findFixingCombinations(X, what, with)
  edges = [];
  f1 = what;
  for j = 1 : size(with,1)
    f2 = [f1 with(j)];
    better = moreDimensionIsBetter(X,f1,f2);
    if better==1
      edges = [ edges ; f2 ];
    end
  end
  if size(edges,1)==0
    disp(f1);
  else
    for j = 1 : size(edges,1)
      findFixingCombinations(X, edges(j,:), setdiff(with,edges(j,:))');
    end
  end
end