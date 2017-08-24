function token = getToken(inputString, delimiter, tokenIndex)

  if nargin<3
    tokenIndex = 1;
  end
  
  if nargin<2
    delimiter = ' ';
  end

  tokenArray = strsplit(inputString, delimiter);
  token = tokenArray{tokenIndex};
  
end