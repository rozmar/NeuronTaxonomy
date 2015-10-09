% Predicts the class label of a timeseries based on multiple class templates.
%
% templates - class templates, one for each class
% timeSeries - time series to predict
% classes - labels of classes
function decision = predictTimeSeriesMultiTemplate(templates, timeSeries, classes)
  classNum = length(classes);
  dist = [];
  
  figure('visible','off');
    
  for i = 1 : classNum
    subplot(2,1,i);
    hold on;
    dist(i) = compareTimeSeries(templates{i}, timeSeries);
    hold off;
  end
    
  [val, pos] = min(dist);

  decision = classes(pos);
			
end
