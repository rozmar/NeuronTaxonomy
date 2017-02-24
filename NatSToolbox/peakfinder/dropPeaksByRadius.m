function remainingPeak = dropPeaksByRadius(timeVector, timeSeries, peakLocation, radius)

  peakTimeVector = timeVector(peakLocation);
  peakLevelVector = timeSeries(peakLocation);

  figure;
  hold on;
  plot(timeVector, timeSeries, 'b-', 'linewidth', 2);
  plot(peakTimeVector, peakLevelVector, 'ro');
  hold off;
  
  remainingIndex = (-radius<=peakTimeVector)&(peakTimeVector<=radius);
  remainingPeak = peakLocation(remainingIndex);
  hold on;
  plot(peakTimeVector(remainingIndex), peakLevelVector(remainingIndex), 'ro', 'markerfacecolor', 'r');
  plot(peakTimeVector(~remainingIndex), peakLevelVector(~remainingIndex), 'kx', 'markersize', 10, 'linewidth', 2);
  hold off;
  
end