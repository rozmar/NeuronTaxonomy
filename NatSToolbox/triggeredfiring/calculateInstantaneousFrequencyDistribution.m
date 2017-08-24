function instFreqDistribution = calculateInstantaneousFrequencyDistribution(eventVector)

  ISIvector = diff(sort(eventVector));
  instFreq  = 1./ISIvector;
  
  instFreqDistribution = histc(instFreq, 0:20:500);
  
  if size(instFreqDistribution,1)>size(instFreqDistribution,2)
    instFreqDistribution = instFreqDistribution';
  end
  
end