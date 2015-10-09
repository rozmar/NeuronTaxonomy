function statObject = calculateStatistics(template, trainSet)
  distVect = [];
  for i = 1 : length(trainSet)
    distVect(i) = compareTimeSeries(template,trainSet{i});
  end	
  
  statObject.avg = mean(distVect);
  statObject.dev = std(distVect);
	
end