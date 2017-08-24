% positionCategory creates category vector based on trigger positions in
% section. If no parameter was given, position itself will be the category.
% If position limit was given, we remove the other labels.
%
% Parameters
%  - inputStructure - first parameter won't be used, it is only for
%    polymorphism
%  - positionVector - the trigger position in section on which
%    categorization will be based on
%  - parameters - categorization can be modified
%     - categorizationLimit - (optional) can retain only specific positions
%     - outlierHandling - (optional) the handling of "outliers" can be
%     specified, until now, only elimination was implemented
% Return values
%  - categoryVector - nx1 vector, the final category labels
function categoryVector = positionCategory(~, positionVector, parameters)
  
  % Default categorization based on
  % section position
  categoryVector = positionVector;
  
  % If we want to limit position to retain
  if isfield(parameters,'categorizationLimit')
    % And we want to eliminate outliers
    if ~isfield(parameters,'outlierHandling')|| strcmpi(parameters.outlierHandling,'elim')
        
      % Get retainable categories
      toRetainCategory = parameters.categorizationLimit;
      % Get possible position 
      positions = unique(positionVector);
      
      % Discard those position labels which we want to eliminate
      for i = 1 : length(positions)
        if ~any(toRetainCategory==positions(i))
          categoryVector(categoryVector==positions(i)) = 0; 
        end
      end
    end
  end
end