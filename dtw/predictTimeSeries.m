% Predicts the class label of a timeseries based on one class template.
%
% If the distance of the given time series and the template is less than
% mu + l * sigma, we accept the time series, else reject.
% template - class template
% timeSeries - time series to predict
% statObject - statistics of the train set
% l - threshold for decision
function decision = predictTimeSeries(template, timeSeries, statObject, l)
  dist = compareTimeSeries(template, timeSeries);
  
  decision = (dist< (statObject.avg + statObject.dev*l));
  
  if decision
    decision = int16(decision);
  else
    decision = 2;
  end
  
end