function findProminenceThresholdForPeak(peakProminences, peakLabels, maxHeights, cellID)
  classLabel             = zeros(size(peakLabels));
  classLabel(peakLabels) = 1;
  maxHeightVector        = zeros(size(peakProminences));
  maxPromVector          = zeros(size(peakProminences));
  threshold              = 0.1;
  nCell                  = length(maxHeights);
  
  for i = 1 : nCell
    maxHeightVector(cellID==i) = maxHeights(i); 
    maxPromVector(cellID==i)   = max(peakProminences(cellID==i));
  end
  
  nonComplex = true(size(cellID));
  nonComplex = nonComplex|(cellID<19);
  of = @(x) optimizationFunc(x, peakProminences(nonComplex), classLabel(nonComplex), maxPromVector(nonComplex), maxHeightVector(nonComplex));
  
  %threshold_opt = fminbnd(of, 0, 100);
  threshold_opt = 10;
  fprintf('Optimal threshold is %f, where accuracy is %f\n', threshold_opt, optimizationFunc(threshold_opt, peakProminences, classLabel, maxPromVector, maxHeightVector));
  
end

function errorRate = optimizationFunc(threshold, peakProminences, classLabel, maxPromVector, maxHeightVector)
  threshold = round(threshold)/100;
  %predVector = (peakProminences>=(threshold*maxPromVector));
  predVector = (peakProminences>=(threshold*maxHeightVector));
  
  %hitrate = calculateAccuracy(classLabel, predVector);
  %errorRate = 1-hitrate;
  %fprintf('Hit rate with threshold %f: %f%%\n', threshold, hitrate*100);
  
  
  errorRate = calculateFalseNegative(classLabel, predVector);
  fprintf('Missed peak: %d/%d\n', errorRate, length(classLabel));
  
  
end

function ACC = calculateAccuracy(classLabel, predVector)
  TPTN = calculateHitNumber(classLabel, predVector);
  totalPopulation = length(classLabel);
  fprintf('Total error %d/%d.\n', (totalPopulation-TPTN), totalPopulation);
  ACC = TPTN / totalPopulation;
end

function FP = calculateFalsePositive(classLabel, predVector)
  FP = sum((classLabel==0)&(predVector==1));
end

function FN = calculateFalseNegative(classLabel, predVector)
  FN = sum((classLabel==1)&(predVector==0));
end

function TPTN = calculateHitNumber(classLabel, predVector)
  TPTN = sum(classLabel==predVector);
end