
function peakLocations = findProminentPeaks(signalVector, timeVector, parameters)

  SI              = min(diff(timeVector));
  minPeakDistance = round(parameters.minDistance/SI);

  [~, oldPeakLocations] = findpeaks(signalVector, 'MINPEAKDISTANCE', minPeakDistance);
  
  peakLocations      = dropPeaksByProminence(timeVector, signalVector, oldPeakLocations, parameters.prominenceRatio);
  
  plotPeaksAndProminences(timeVector, signalVector, oldPeakLocations);
  hold on;
  plot(timeVector(peakLocations), signalVector(peakLocations), 'ro', 'markerfacecolor', 'r');
  plot(timeVector(~peakLocations), signalVector(~peakLocations), 'kx', 'markersize', 10, 'linewidth', 2);
  hold off;
    
end