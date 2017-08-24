% drawVerticalLine draws a vertical line between the given points. Color
% and width of the line can be provided in parameters.
%
% Parameter
%  xVal - x coordinate of line
%  yVal1 - y coordinate of the first end of the line
%  yVal2 - y coordinate of the second end of the line
%  color - color of the line
%  width - line width of the line
function drawVerticalLine(xVal, yVal1, yVal2, color, width)
  drawLine([xVal,yVal1], [xVal,yVal2], color, width);
end