% checkFieldExist checks whether the given fieldname exists in the structure.
% If the given field doesn't exists, raise an error.
% 
% Parameters
%  - S - inputStructure, which will be checked for field existence
%  - fieldName - name of the field which we want to use
function checkFieldExist(S, fieldName)  
  if ~isfield(S, fieldName)
    showError(sprintf('Field ''%s'' is missing!',fieldName));
  end
end