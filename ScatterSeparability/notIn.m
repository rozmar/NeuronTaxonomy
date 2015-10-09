

function result = notIn(V,v)
  for i = 1 : size(V,1)
    if size(setdiff(V(i,:),v),2)==0
      result=0;
      return;
    end
  end
  result = 1;
end