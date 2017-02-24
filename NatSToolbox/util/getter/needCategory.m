% needCategory decides wheter categorization is needed
%
% Parameter
%  - parameters - parameter structure which contains the settings
% Return value
%  - answer - result of decision (true or false)
function answer = needCategory(parameters)
  answer = isfield(parameters,'categorization')&&parameters.categorization.toCategorize; 
end