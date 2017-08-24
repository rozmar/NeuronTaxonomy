function figHandle = plotPeaksAndProminences(timeVector, timeSeries, peakLocations, neighbors, prominentSide, reference)

  figHandle = figure;
  hold on;
  plot(timeVector, timeSeries, 'b-', 'linewidth', 2);
  plot(timeVector(peakLocations), timeSeries(peakLocations), 'ro');
  hold off;
  
  if nargin==3
    return;
  end
  
  hold on;
  for i = 1 : length(peakLocations)
    thisPeakLoc = peakLocations(i);
    thisNeighbors = neighbors(i,:);
    thisLevel = peakLevels(i);
    thisReference = reference(i);
    thisPromSide = prominentSide(i);
      
    plot(timeVector([thisNeighbors(thisPromSide),thisPeakLoc]),[thisLevel,thisLevel],'k--');
    plot(timeVector([1,1]*thisPeakLoc), [thisLevel, thisReference], 'r--');
      
  end
  hold off;
end