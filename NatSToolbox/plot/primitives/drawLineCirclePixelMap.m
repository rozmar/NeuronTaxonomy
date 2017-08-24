function newPixelMap = drawLineCirclePixelMap(endPoint, pixelMap)
  
  [row, col] = size(pixelMap);
  
  xAxis      = linspace(-1,1,col);
  yAxis      = linspace(-1,1,row);

  EP = [real(endPoint), imag(endPoint)];    % x and y coordinates of endpoint
  m = EP(2)/EP(1);                          % calculate line slope (y/x)
  
  % Find endpoint coordinates in axes
  tvXI = dsearchn(xAxis', EP(1));
  % Find zero point's coordinates in axes
  zeroXI = dsearchn(xAxis',0);
  
  % Index of sample points
  lineXI = min(zeroXI,tvXI):max(zeroXI,tvXI);
  % X-values at sample points
  lineX = xAxis(lineXI);
  % Y-values at sample points
  lineY = lineX*m;
  % Index in Y axis
  lineYI = dsearchn(yAxis', lineY')';
  
  linearIndex = @(x,y,r) (x-ones(size(x)))*r + y;
  pixelMap(linearIndex(lineXI, lineYI, col)) = 1;
  newPixelMap = pixelMap;
end