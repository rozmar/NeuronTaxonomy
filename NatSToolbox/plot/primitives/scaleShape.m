function translatedShape = scaleShape(originalShape, scalingFactor)
  scalingMatrix   = eye(2).*scalingFactor;
  translatedShape = transformShape(originalShape, scalingMatrix);    
end