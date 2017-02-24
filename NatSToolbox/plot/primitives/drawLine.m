% drawLine draws a line between two point given with their coordinates. The
% color and width of the line can be provided in parameter.
%  
% Parameters
%  - P1 - [x1,y1] coordinates of the first endpoint
%  - P2 - [x2,y2] coordinates of the second endpoint
%  - color - color of the line
%  - width - width of the line
function drawLine(P1, P2, color, width)
  plot([P1(1),P2(1)],[P1(2),P2(2)],'-', 'color', color, 'LineWidth', width);
end
