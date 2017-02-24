% printConditionalProbabilities Displays the single and joint
% probabilities and then the conditional probabilities.
%
% Parameters
%  - probabilities - result structure with following fields
%    - single - P(A) and P(B)
%    - joint  - P(A&B) and P(~A&~B) and P(~A&B) and P(A&~B)
%    - conditional - P(A|B), P(B|A), P(A|~B), P(B|~A)
%  - names - 2x1 string array (optional), the name of events. If not given,
%  A and B will be shown
function printConditionalProbabilities(probabilities, names)

  % If names hasn't been 
  % given, use A and B
  if nargin<2
    names = {'A','B'}; 
  end

  % Print single prob.
  for i = 1 : 2
    fprintf('P(%s) = %.3f\n', names{i}, probabilities.single(i));
  end
  
  % Print joint probs.
  fprintf('P(%s&%s) = %.3f\n', names{1}, names{2}, probabilities.joint(1,1));
  fprintf('P(%s&~%s) = %.3f\n', names{1}, names{2}, probabilities.joint(1,2));
  fprintf('P(~%s&%s) = %.3f\n', names{1}, names{2}, probabilities.joint(2,1));
  fprintf('P(~%s&~%s) = %.3f\n', names{1}, names{2}, probabilities.joint(2,2));
  
  % Print conditional probs.
  fprintf('P(%s|%s) = %.3f\n', names{1}, names{2}, probabilities.conditional(1,1));
  fprintf('P(%s|~%s) = %.3f\n', names{1}, names{2}, probabilities.conditional(1,2));
  fprintf('P(%s|%s) = %.3f\n', names{2}, names{1}, probabilities.conditional(2,1));
  fprintf('P(%s|~%s) = %.3f\n', names{2}, names{1}, probabilities.conditional(2,2));
end