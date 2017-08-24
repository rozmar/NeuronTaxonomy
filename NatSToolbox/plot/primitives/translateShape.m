function translatedShape = translateShape(originalShape, translationVector)
  translationMatrix = eye(3);
  translationMatrix(1:2,end) = translationVector;
  translatedShape   = transformShape([originalShape;ones(1,size(originalShape,2))], translationMatrix);    
  translatedShape    = translatedShape(1:end-1,:);
end