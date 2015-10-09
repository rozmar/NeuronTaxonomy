

function plotEvaluationSet(template, evaluationSet)
  for i = 1 : length(template)
    figure;
    clf;
    hold on;
    plot(template,'k-');
    plot(evaluationSet{i},'b-');
    hold off;
  end
end