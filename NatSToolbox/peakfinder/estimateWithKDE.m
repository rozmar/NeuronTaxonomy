% estimateWithKDE estimates the given data over the given interval using
% Kernel density estimation so that the resulting distribution fit the
% original data at least p>alpha significance level according to the
% Kolmogorov-Smirnov goodness-of-fit test.
function [smoothedData,smoothedTime] = estimateWithKDE(dataVector, timeVector, alpha)

  if nargin<3
    alpha = 0.9; 
  end

  fprintf('Number of events: %d\n', length(dataVector));
  
  bandwithFinderParameters = struct('alpha', alpha, 'printMode', 1);

  h = findBestBandwidth(dataVector, timeVector, bandwithFinderParameters);
  
  [smoothedData,smoothedTime] = ksdensity(dataVector, timeVector, 'Bandwidth', h);
  
end