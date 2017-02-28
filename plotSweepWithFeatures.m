function plotSweepWithFeatures(ivStructure, sweepNumber, featureMatrix)
  
  time = ivStructure.time;
  signal = getSweepSignal(ivStructure, sweepNumber);
  
  featureMatrix = getSweepAPMatrix(featureMatrix, sweepNumber);
  
  figure;
  hold on;
  plot(time, signal, 'b-');
  
  apMaxPos = getFeatureByName(featureMatrix, 'apMaxPos');
  thresholdPos = getFeatureByName(featureMatrix, 'thresholdPos');
  
  scatter(time(apMaxPos), signal(apMaxPos), 'r', 'filled');
  scatter(time(thresholdPos), signal(thresholdPos), 'g', 'filled');
  
  hold off;
  
end

function signal = getSweepSignal(ivStructure, sweepIdx)
  signal = ivStructure.(sprintf('v%d', sweepIdx));
end

function featureMatrix = getSweepAPMatrix(featureMatrix, sweepID)
  thisSweepFlag = (featureMatrix(:,1) == sweepID);
  featureMatrix = featureMatrix(thisSweepFlag,:);
end

function featureVector = getFeatureByName(featureMatrix, featureName)
  featureStructure = struct('name', ...
    {'apMaxPos', 'thresholdPos'}, ...
    'index', {3, 4});
  
  thisFeatureIndex = find(strcmpi({featureStructure.name}, featureName), 1);
  
  if ~isempty(thisFeatureIndex)
    featureVector = featureMatrix(:,featureStructure(thisFeatureIndex).index);
  else
    throw(MException('NeuronTaxonomy:IllegalArgument','Wrong feature name: %s', featureName));
  end
  
end