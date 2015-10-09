
vectors = {};

for i = 1 : length(cells)
  if size(cells{i}.values,1)==1
    continue
  end
  for j = 1 : size(cells{i}.values,1)
    vectors{length(vectors)+1}.key = cells{i}.key;
    vectors{length(vectors)}.values = X(cells{i}.values,:)
  end
end