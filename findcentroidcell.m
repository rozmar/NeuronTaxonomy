
closestNGFdist = 100;
closestNGFind = 0;
closestNNGFdist = 100;
closestNNGFind = 0;

for i = 1 : size(bestFeatures,2)

  [idx,c] = kmeans(FNX(:,bestFeatures(i)),2);
  for j = 1 : size(NX,1)
    dist1 = abs(c(1)-NX(j,i));
    dist2 = abs(c(2)-NX(j,i));
    if dist1 < closestNGFdist && y(j)==1
      closestNGFdist = dist1;
      closestNGFind = j;
    elseif dist2 < closestNNGFdist && y(j)==-1
      closestNNGFdist = dist2;
      closestNNGFind = j;
    end
  end
  closestDiffs(i).c = c;
  closestDiffs(i).ids = [closestNGFind;closestNNGFind];
end 