


function [better,idx1,idx2] = moreDimensionIsBetter(X,i,j,type,direction)
  F1 = X(:,i);
  F2 = X(:,j);
  [idx1,c1] = kmeans(F1,2,'emptyaction','singleton','Display','off');
  [idx2,c2] = kmeans(F2,2,'emptyaction','singleton','Display','off');
  if idx2(1)==2 ;
    idx2 = repmat(3,size(idx2,1),1)-idx2;
  end
  if idx1(1)==2 ;
    idx1 = repmat(3,size(idx1,1),1)-idx1;
  end
  idx1(idx1==2)=0;
  idx2(idx2==2)=0;
  PI1 = [];
  PI2 = [];
  
  PI1(1) = size(idx1(idx1==1),1)/size(idx1,1);
  PI1(2) = size(idx1(idx1==0),1)/size(idx1,1);
  PI2(1) = size(idx2(idx2==1),1)/size(idx2,1);
  PI2(2) = size(idx2(idx2==0),1)/size(idx2,1);
  
  CRITF1C1 = scatterSeparability(F1,idx1,PI1);
  CRITF2C2 = scatterSeparability(F2,idx2,PI2);
  CRITF1C2 = scatterSeparability(F1,idx2,PI2);
  CRITF2C1 = scatterSeparability(F2,idx1,PI1);
  
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
