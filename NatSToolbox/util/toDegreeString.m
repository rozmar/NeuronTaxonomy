% Create a string which displays an angle in degree.
function degString = toDegreeString(angleInRad)
  degString = sprintf('%.2f%c', circ_rad2ang(angleInRad), char(176));
end