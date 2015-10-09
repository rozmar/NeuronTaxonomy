
silh2 = [];
for i = 1 : size(NXA,1)

  a = [];
  b = [];
  for j = 1 : size(NXA,1)
    if i==j
      continue
    end
    diff = NXA(j,best).-NXA(i,best);
    dist = sqrt(diff*diff');
    if midx2(i)==midx2(j)
      a = [ a ; dist ];
    else
      b = [ b ; dist ];
    end
  end
  
  silh2(i) = (mean(b)-mean(a))/max(mean(a),mean(b));
end