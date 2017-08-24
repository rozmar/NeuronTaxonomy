% calculateConditionalProbabilities Calculates the conditional
% probabilities according to the Bayes rule. 
%
% Parameters
%  - A - nx1 vector (logical or double {0,1}) indicates the first event
%  occurrences
%  - B - nx1 vector (logical or double {0,1}) indicates the second event
%  occurrences
% Return value
%  - probabilities - result structure with following fields
%    - single - P(A) and P(B)
%    - joint  - P(A&B) and P(~A&~B) and P(~A&B) and P(A&~B)
%    - conditional - P(A|B), P(B|A), P(A|~B), P(B|~A)
function probabilities = calculateConditionalProbabilities(A, B)

  %% -----------------------
  %  Count number of cases
  %% -----------------------
  
  % All case
  nCases = length(A);
  
  % Single cases
  nA = sum(A);
  nB = sum(B);
  
  % Joint cases
  nA_and_B   = sum((A==1)&(B==1));
  nA_and_NB  = sum((A==1)&(B==0));
  nNA_and_B  = sum((A==0)&(B==1));
  nNA_and_NB = sum((A==0)&(B==0));
  %% -----------------------
  
  %% -----------------------
  %  Calculate probabilities
  %% -----------------------
  probabilities.single = [nA nB]./nCases;
  probabilities.joint  = [nA_and_B nA_and_NB ; nNA_and_B nNA_and_NB]./nCases;
  
  P_A_cond_B  = probabilities.joint(1,1) /probabilities.single(2);
  P_A_cond_NB = probabilities.joint(1,2) /(1-probabilities.single(2));
  P_B_cond_A  = probabilities.joint(1,1) /probabilities.single(1);
  P_B_cond_NA = probabilities.joint(2,1) /(1-probabilities.single(1));
  
  probabilities.conditional = [P_A_cond_B P_A_cond_NB ; P_B_cond_A P_B_cond_NA ];
  %% -----------------------
  
end