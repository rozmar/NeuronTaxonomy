function [resultStructure, parameters] = collectHistogram(inputStructure, parameters) 
  resultStructure.value = inputStructure.resultStructure.(parameters.source.histogramType);
  resultStructure.name  = getToken(inputStructure.title, '_', 1);
end