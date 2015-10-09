% Evaluates a given model (template) with a specified set.
%
% template - the model, learned template
% evaluationSet - the set to evaluate
% labels - true labels 
% statObject - part of the model, statistics of the training set
% l - threshold which have to be optimized

function [acc, F1, cfm] = evaluateSet(template, evaluationSet, labels, statObject, l)
  cfm = zeros(2,2);
  for i = 1 : length(evaluationSet)
    decision = predictTimeSeries(template, evaluationSet{i}, statObject, l);
    cfm(int16(decision),labels(i)) =  cfm(int16(decision),labels(i)) + 1;
  end
  tp = cfm(1,1);
  precision = tp / (sum(cfm(1,:)));
  recall = tp / (sum(cfm(:,1)));
  F1 = (2*precision*recall) / (precision+recall);
  acc = (cfm(1,1) + cfm(2,2)) / (sum(sum(cfm)));
end