% toStringAllCondition converts each condition into string and concatenates
% them into a long string, which can be for logging and plot title. If any
% section parameter was given, starts with them, after that will append the
% trigger conditions (if any of them was given).
% 
% Parameters
%  - parameters - parameter structure, which contains all condition
% Return value
%  - resultString - the string which contains all condition as a string  
function resultString = toStringAllCondition(parameters)
  resultString = '';
  
  if isfield(parameters,'section')
    secParam = parameters.section;
    resultString = strjoin({resultString,' ',secParam.title,':'},'');
    conditionString = '';
    if isfield(secParam, 'conditions')
      for c = 1 : length(secParam.conditions)
        conditionString = strjoin({conditionString,conditionToString(secParam.conditions(c))},' '); 
      end
      resultString = strcat(resultString,conditionString);
    end
  end
end