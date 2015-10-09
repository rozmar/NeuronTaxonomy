
PM = makePermutation(length(bestFeatureCombination),2)

for i = 1 : size(PM,1)
  F = X(:,bestFeatureCombination(PM(i,:)));
  mX = mean(F);
  sX = std(F);
  NF = (F.-mX)./sX;
  idx = kmeans(F,2,'emptyaction','singleton');
  figure(i); clf;
  subplot(2,1,1);
  hold on;
  plot(F(idx==1,1),F(idx==1,2),'r.','markersize',5);
  plot(F(idx==2,1),F(idx==2,2),'r.','markersize',5);
  title([featureList{bestFeatureCombination(PM(i,1))},'-',featureList{bestFeatureCombination(PM(i,2))}]);
  hold off;
  subplot(2,1,2);
  hold on;
  plot(NF(idx==1,1),NF(idx==1,2),'r.','markersize',5);
  plot(NF(idx==2,1),NF(idx==2,2),'r.','markersize',5);
  hold off;  
end