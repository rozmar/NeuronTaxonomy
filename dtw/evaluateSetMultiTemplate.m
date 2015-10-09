% Evaluates a given model (more templates) with a specified set.
%
% templates - the model, learned templates, one for each class
% evaluationSet - the set to evaluate
% labels - true labels 
function [acc, F1, cfm] = evaluateSetMultiTemplate(templates, evaluationSet, labels)
  cfm = zeros(2,2);
  classes = unique(labels);
  fprintf('Evaluate templates on %d test instance\n', length(evaluationSet));
  for i = 1 : length(evaluationSet)
    fprintf('Processing %d/%d test instance...\n', i, length(evaluationSet));
    fflush(stdout);
    decision = predictTimeSeriesMultiTemplate(templates, evaluationSet{i}, classes);
    title(['Decision ',num2str(decision),' Real:', num2str(labels(i))]);
    %fprintf('Decision: %d Real: %d\n', decision, labels(i));
    cfm(int16(decision),labels(i)) =  cfm(int16(decision),labels(i)) + 1;
    if int16(decision)~=labels(i)
      %disp(i);
      %set(gcf,'visible','on');
    end
  end
  tp = cfm(1,1);
  precision = tp / (sum(cfm(1,:)));
  recall = tp / (sum(cfm(:,1)));
  F1 = (2*precision*recall) / (precision+recall);
  acc = (cfm(1,1) + cfm(2,2)) / (sum(sum(cfm)));
end
