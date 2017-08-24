% iterateStructure iterates through an input structure and applies the
% given function to the given field of the structure (similar to cellfun).
% 
% Parameters
%  - inputStructure - nx1 structure array which have to be iterated
%  - fieldName - name of the field on which the given function have to be
%    applied
%  - functionHandle - handle of the function which we want to apply
% Return value
%  - outputStructure - the input structure after application of the
%    function
function outputStructure = iterateStructure(inputStructure, fieldName, functionHandle)

  %% -------------------------
  %  Initialize
  %% -------------------------
  outputStructure = inputStructure;
  %% -------------------------
  
  %% -------------------------
  %  Check existence of field
  %% -------------------------
  if ~isfield(inputStructure,fieldName)
    showError(sprintf('iterateStructure: Field %s doesn''t exist in input Structure!'));
  end
  %% -------------------------
  
  %% -------------------------
  %  Apply the function
  %% -------------------------
  for i = 1 : length(outputStructure)
    outputStructure(i).(fieldName) = functionHandle(outputStructure(i).(fieldName)); 
  end
  %% -------------------------
end