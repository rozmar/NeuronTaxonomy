% getMarkersByField returns the given field's values from the input structure, if it presents.
% Else throws an error.
% 
% Parameters
%  - inputStructure - structure where values are stored
%  - fieldName - name of the channel which have to be retained
% Return value
%  - returnVector - the time vector represents the requested markers
function returnVector = getMarkersByField(inputStructure, fieldName)

  if ~isfield(inputStructure, fieldName)
    showError(sprintf('Field ''%s'' in input file is missing!', fieldName));
  end
    
  returnVector = inputStructure.(fieldName).times;

end