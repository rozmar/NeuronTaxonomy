function plotMVDChangeLine(meanVectors)

  nCycle = length(meanVectors);
  yCoords = angle(meanVectors');
  
  plot( yCoords, (1:nCycle)', 'b-');
  

end
