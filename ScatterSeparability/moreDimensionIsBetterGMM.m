


function [better,idx1,idx2] = moreDimensionIsBetterGMM(X,i,j,iter,type,direction)
  F1 = X(:,i);
  F2 = X(:,j);
  opt = statset('MaxIter',500);
  IDX1 = [];
  IDX2 = [];
  for it = 1 : iter 
    gm1 = gmdistribution.fit(F1,2,'Options',opt,'Regularize',1e-5);
    gm2 = gmdistribution.fit(F2,2,'Options',opt,'Regularize',1e-5);
    idx1 = cluster(gm1,F1);
    idx2 = cluster(gm2,F2);
    if idx1(1)==2 ;
        idx1 = repmat(3,size(idx1,1),1)-idx1;
    end
    if idx2(1)==2 ;
       idx2 = repmat(3,size(idx2,1),1)-idx2;
    end
    IDX1 = [ IDX1 ; idx1' ];
    IDX2 = [ IDX2 ; idx2' ];
  end
  idx1 = mode(IDX1);
  idx2 = mode(IDX2);
  CRITF1C1 = scatterSeparability(F1,idx1);
  CRITF2C2 = scatterSeparability(F2,idx2);
  CRITF1C2 = scatterSeparability(F1,idx2);
  CRITF2C1 = scatterSeparability(F2,idx1);
  if strcmp(type,'mul')==1
    NF1C1 = CRITF1C1 * CRITF2C1;
    NF2C2 = CRITF2C2 * CRITF1C2;
  elseif strcmp(type,'add')==1
    NF1C1 = CRITF1C1 + CRITF2C1;
    NF2C2 = CRITF2C2 + CRITF1C2;
  elseif strcmp(type,'penalty')==1
    NF1C1 = CRITF1C1 / size(i,2);
    NF2C2 = CRITF2C2 / size(j,2);
  end
  NF1C1;
  NF2C2;
  if strcmp(direction,'upward')==1          %if we go from smaller to larger feature sets, we accept only strictly larger combinations
      better = NF2C2>NF1C1;
  elseif strcmp(direction,'downward')==1
      better = NF2C2>=NF1C1;
  end
end
