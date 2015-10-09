function  [NF1C1,NF2C2] = normalizeCriterion(X,i,j,idx1,idx2,type)
  F1 = X(:,i);
  F2 = X(:,j);
  CRITF1C1 = scatterSeparability(F1,idx1)
  CRITF2C2 = scatterSeparability(F2,idx2)
  CRITF1C2 = scatterSeparability(F1,idx2)
  CRITF2C1 = scatterSeparability(F2,idx1)
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
end