

function [modeIdx probs] = getModeClusteringAccuracies(F,n)
  if nargin<2
    n = 10;
  end
  ID = [];
  for i = 1 : n 
    [idx,c] = kmeans(F,2);
    ID = [ ID ; idx' ];
  end
  idFirst = ID(1,:);
  for i = 2 : n
    idI = ID(i,:);
    match = (idFirst==idI);
    if mean(match)<0.5
      idI = repmat(3,1,size(idI,2)) .- idI;
      ID(i,:) = idI;	
    end
  end
  modeIdx = mode(ID);
  MatchMatrix = (ID==modeIdx);
  probs = mean(MatchMatrix);
end