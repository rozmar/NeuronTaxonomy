function naiveBayesSpindleClassifier(parameters)
  inputDir = parameters.input.dir;
  inputFile = parameters.input.file;
  
  S = load(strcat(inputDir,'/',inputFile));
  
  signalChannel = S.wideband;
  
  segmentStructure = getSingleSegment(S, struct('segmentName','spdl'));
  invertedSegmentStructure = invertSegmentStructure(segmentStructure, signalChannel.times([1,end]));
  
  filterParam = struct('filterType', 'butter', 'filterOrder', 2, 'filterBounds', [12,16], 'Fs', round(1/signalChannel.interval));
  filteredSignal = filterSignal(signalChannel.values, filterParam);
  hilbertSignal = hilbert(filteredSignal);
  amplitudeSignal = abs(hilbertSignal);
  
  hilbertStructure = struct('times',signalChannel.times,'values',amplitudeSignal);
  segmentAmplitudes = cutSegments(hilbertStructure, segmentStructure);
  outsidesegmentAmplitudes = cutSegments(hilbertStructure, invertedSegmentStructure);
  
  segmentAmplitudes = cell2mat(segmentAmplitudes);
  outsidesegmentAmplitudes = cell2mat(outsidesegmentAmplitudes);
  
  histEdges = (0:1e-3:max([segmentAmplitudes;outsidesegmentAmplitudes]))';
  segm_num = histc(segmentAmplitudes, histEdges);
  nsegm_num = histc(outsidesegmentAmplitudes, histEdges);
  segm_num = segm_num./sum(segm_num);
  nsegm_num = nsegm_num./sum(nsegm_num);
  
  figure;
  hold on;
  plot(histEdges, segm_num, 'b-', 'linewidth', 2);
  plot(histEdges, nsegm_num, 'r-', 'linewidth', 2);
end