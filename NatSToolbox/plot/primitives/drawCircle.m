% drawCircle draws a circle on the plane with given u,v central point and r
% radius.
function drawCircle(o, r, resolution)

  if nargin<3
    resolution = 720;
  end

  sampleDegrees = circ_ang2rad(linspace(0,360, resolution+1));
  
  xCoords = r*cos(sampleDegrees) + o(1);
  yCoords = r*sin(sampleDegrees) + o(2);
  
  plot(xCoords, yCoords, 'k-');
end