function bests = getTopFeatures(RS,outfilePath)
  for i=1:length(RS)
    if i==1
      bests(i).best = unique(RS(i).R(:,1));
      continue;
    end
    if i>3
      R = RS(i).R(RS(i).R(:,end)<1,:);
    else
      R = RS(i).R(RS(i).R(:,end)<3,:);
    end
    best = unique(R(:,1));
    for j=2:i
      best = union(best,unique(R(:,j)));
    end
    bests(i).best=best;
    bests(i).R = R;
  end
end