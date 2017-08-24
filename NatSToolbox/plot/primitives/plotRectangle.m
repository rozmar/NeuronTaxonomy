% This function plots a rectangle specified by its top left and bottom
% right edge. Its color can be specified. The default color is blue.
% 
% Parameters
%  - topLeft - 2x1 vector, holds the (x,y) coordinates
%  - bottomRight - 2x1 vector, holds the (x,y) coordinates
%  - color (optional) - 3x1 vector, holds the RGB values of the fill color
function plotRectangle(topLeft, bottomRight, color)

  % Set default color to blue
  if nargin<3
    color = [0,0,1]; 
  end

  % Draw the rectangle
  fill([topLeft(1),topLeft(1),bottomRight(1),bottomRight(1)], ...
      [topLeft(2),bottomRight(2),bottomRight(2),topLeft(2)], ...
      color);
end