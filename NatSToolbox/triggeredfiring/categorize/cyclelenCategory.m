% cyclelenCategory creates category vector based on triggers' containing
% cycle length. If no parameter was given, each trigger will belong to the
% same category. Else, categories will be assigned by by the length of
% cycle.
%
% Parameters
%  - inputStructure - first parameter won't be used, it is only for
%    polymorphism
%  - neighborMatrix - the neighbor matrix, which contains the neighbor ends
%  - parameters - categorization can be modified
%     - categorizationLimit - (optional) can retain only specific positions
%     - outlierHandling - (optional) the handling of "outliers" can be
%     specified, until now, only elimination was implemented
% Return values
%  - categoryVector - nx1 vector, the final category labels
function categoryVector = cyclelenCategory(~, neighborMatrix, parameters)
  
  % Calculate cycle lengths from neighbor values
  cycleLengthVector = diff(neighborMatrix,1,2);
  % Default categorization: everything in the same category
  categoryVector = ones(size(cycleLengthVector));
  
  % If we want to limit position to retain
  if isfield(parameters,'categorizationLimit')
    % And we want to eliminate outliers
    if ~isfield(parameters,'outlierHandling')|| ...
            strcmpi(parameters.outlierHandling,'elim')
        
      % Get retainable categories
      toRetainCategory = parameters.categorizationLimit;
      % Get possible position 
      [~,categoryVector] = histc(cycleLengthVector, toRetainCategory);
    end
  end
end