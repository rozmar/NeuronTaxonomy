function plotPeritriggerEventRaster(periEventArray, parameters)
 
  rasterSize   = 1;
  rasterOffset = 0.1;
  color        = 'k';
  
  if isfield(parameters, 'rasterSize')
    rasterSize = parameters.rasterSize; 
  end
  
  if isfield(parameters, 'rasterOffset')
    rasterOffset = parameters.rasterOffset; 
  end
  
  if isfield(parameters, 'color')
    color = parameters.color; 
  end
  
  nTrigger = length(periEventArray);
  
  hold on;
  for i = 1 : nTrigger
    thisOffset       = (i-1)*rasterOffset;
    thisTriggerEvent = periEventArray{i};
    thisEventNum     = length(thisTriggerEvent);
    for j = 1 : thisEventNum 
      currentEvent = thisTriggerEvent(j);
      drawLine([currentEvent, thisOffset], [currentEvent, thisOffset+rasterSize], color, 1);
    end
  end
  hold off;
  
end