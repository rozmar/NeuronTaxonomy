function eyeProof(NX,R,featureList)
  [~,i] = sort(R(:,3),'descend');
  R=R(i,:);
  
  for i=1:min(10,size(R,1))
    F = NX(:,R(i,1:end-1));
    F = removeOutliers(F,1);
    [idx,c] = kmeans(F,2);
    figure(i);
    clf;
    plot(F(idx==1,1),F(idx==1,2),'bo',F(idx==2,1),F(idx==2,2),'ro');
    title([featureList{R(i,1)},' - ',featureList{R(i,2)}]);
  end	
end