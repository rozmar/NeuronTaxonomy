function concavity = calculateConcavity(timeSeries)
  
  linex = (1:1:length(timeSeries));
  liney = [];
    
  stepSize = (timeSeries(end)-timeSeries(1))/(length(timeSeries)-1);
  for i = 1 : length(timeSeries)
    liney(i)= timeSeries(1) + (i-1)*stepSize;
  end
  
  
  %plot(linex,timeSeries,'b-');
  %plot(linex,liney,'r-');
  
  concavity = sum(timeSeries.-liney);
  concavitymean = mean(timeSeries.-liney);
  
end