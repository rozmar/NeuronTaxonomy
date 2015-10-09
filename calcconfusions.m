
y(y==2)=0;
acc = 0;

for i = 1 : size(bestFeatures(1).R,1)
  F = NX(:,bestFeatures(1).R(i,1));
  idx = kmeans(F,2);
  idx(idx==2)=0;
  ccm = calcConfusionMatrixClustering(F,idx,y);
  printf("Confusion matrix for %s:\n", featureList{bestFeatures(1).R(i,1)});
  disp(ccm);
  printf("Accuracy: %f\n", (sum(ccm([1,4]))/sum(ccm)));
  acc += (sum(ccm([1,4]))/sum(ccm));
end

  printf("Average accuracy: %f\n", (acc/size(bestFeatures(1).R,1)));