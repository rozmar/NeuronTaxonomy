for i = 1 : size(PM,1) ; 
  c = corr(XA(:,bestFeatures(PM(i,1))),XA(:,bestFeatures(PM(i,2))));
  if abs(c)>0.7
    printf("%s(%d) %s(%d)\n", featureList{bestFeatures(PM(i,1))}, bestFeatures(PM(i,1)), featureList{bestFeatures(PM(i,2))}, bestFeatures(PM(i,2))); 
    disp(c);
  end
end;