function [template,r] = updateTemplateSweep(sweep1,sweep2,trace,rold)
  template = sweep1;
  r = rold;
  
  for i = 1 : length(template)
    alignedPoints = trace(trace(:,2)==i,1);
    
    k = size(alignedPoints,1);
    if k==0
      continue
    end
    
    for j = 1 : k
      template(i) = template(i) + sweep2(alignedPoints(k));
    end
    template(i) = template(i) / (k+1);
    r(i)=r(i)+k;
    
  end
end