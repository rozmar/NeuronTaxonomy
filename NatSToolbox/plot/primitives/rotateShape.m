function rotatedShape = rotateShape(originalShape, theta)
  rotationMatrix = [cos(theta) -sin(theta) ; ...
                    sin(theta)  cos(theta) ];
  rotatedShape   = transformShape(originalShape, rotationMatrix);              
end