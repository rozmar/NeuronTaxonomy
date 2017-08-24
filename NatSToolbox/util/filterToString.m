function stringValue = filterToString(filterParameters, type)
  if isempty(filterParameters)
    stringValue = 'raw';
  elseif length(filterParameters)==1
    stringValue = sprintf('%dHz %s', filterParameters, type); 
  elseif length(filterParameters)==2
    stringValue = sprintf('[%d,%d]Hz bandpass', filterParameters);
  end
end