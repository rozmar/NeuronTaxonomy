% This function returns the coordinates of an arrowhead. By default, points
% to East (right) and is 2 unit long. By using transformations can be
% shifted, scaled and rotated to the desired direction.
function arrowCoordinates = drawArrowHead()
 arrowCoordinates = ...
     [1,-1,0,-1,1;...
     0,1,0,-1,0];
end