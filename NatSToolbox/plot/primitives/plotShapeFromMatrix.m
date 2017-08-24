function plotShapeFromMatrix(shapeVectors, color)

  % Set default color to red
  if nargin<2
    color = [1,0,0];
  end

  h = fill(shapeVectors(1,:), shapeVectors(2,:), 'r');
  set(h, 'FaceColor', color);
  set(h, 'EdgeColor', 'none');
end