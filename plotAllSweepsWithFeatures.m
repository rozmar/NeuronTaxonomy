function plotAllSweepsWithFeatures(ivStructure, apFeatures)

  firingSweepIdx = unique(apFeatures(:,1));
  numFiringSweep = length(firingSweepIdx);
  
  for i = 1 : numFiringSweep
    plotSweepWithFeatures(ivStructure, firingSweepIdx(i), apFeatures);
    title(sprintf('%s, Sweep %d', ivStructure.cellName, firingSweepIdx(i)));
  end
  

end