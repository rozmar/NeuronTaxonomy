% Converts a condition structure to string.
function convertedString = conditionToString(condition, mode)

  % Handle invert
  if nargin==2 && strcmpi(mode, 'inv')
    condition.type = ~(condition.type);
  end

  % Create string
  if condition.type==1
    convertedString = sprintf('is %s in [%.4f,%.4f]', condition.marker, condition.interval);
  else
    convertedString = sprintf('no %s in [%.4f,%.4f]', condition.marker, condition.interval); 
  end
end