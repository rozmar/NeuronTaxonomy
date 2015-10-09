

function result = notIn(V,v)
  for i = 1 : size(V,1)
    if sum(unique(V(i,:))==unique(v))==size(v,2)==0
      V(i,:)
      v

    end
  end	
end