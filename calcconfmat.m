
confmat = zeros(1,4);
for i = 1 : size(id,1)
  if indexes(i)==0
    continue;
  end
  if id(i)==1 && idM(indexes(i))==1
    confmat(1)++;
  elseif id(i)==2 && idM(indexes(i))==2
    confmat(4)++;
  elseif id(i)==1 && idM(indexes(i))==2
    confmat(3)++;
  elseif id(i)==2 && idM(indexes(i))==1
    confmat(2)++;
  end
end