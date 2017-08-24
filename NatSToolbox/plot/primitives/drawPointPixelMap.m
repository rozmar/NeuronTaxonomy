function newPixelMap = drawPointPixelMap(x, y, endPoint, pixelMap, pointCount)

  [row, col] = size(pixelMap);
    
  SI = 2/(row-1);
  EP = [real(endPoint), imag(endPoint)];    % x and y coordinates of endpoint
  m = EP(2)/EP(1);                          % calculate line slope (y/x)
  
  % Find endpoint coordinates in axes
  tvXI = dsearchn(x', EP(1));
  tvYI = dsearchn(y', EP(2));
    
%   linearIndex = @(x,y,r) (x-ones(size(x)))*r + y;
  smallNorm = @(x) normpdf((-((x-1)/2)):(((x-1)/2)),0,1);
  pointValue = smallNorm(pointCount);
  
  leftPoint = -((pointCount-1)/2);
  rightPoint = -leftPoint;
  
%   cnt = 1;
%   for i = leftPoint : rightPoint
%     if tvYI+i>=1 && tvYI+i<=col
%         pixelMap(tvXI, tvYI+i) = pixelMap(tvXI, tvYI+i) + 1;%pointValue(cnt);
%     end
%     if tvXI+i>=1 && tvXI+i<=row
%       pixelMap(tvXI+i, tvYI) = pixelMap(tvXI+i, tvYI) + 1;%pointValue(cnt);
%     end
%     cnt = cnt + 1;
%   end
  
  % Loop through rows
  for r = 0 : ((pointCount-1)/2)
    pixelMap( min(max(tvYI+leftPoint+r,1),row) , max(tvXI-r,1):min(tvXI+r,col) ) = pixelMap( min(max(tvYI+leftPoint+r,1),row) , max(tvXI-r,1):min(tvXI+r,col) ) + 1;
  end

  for r = 0 : ((pointCount-1)/2)-1
    pixelMap( min(max(tvYI+rightPoint-r,1),row) , max(tvXI-r,1):min(tvXI+r,col) ) = pixelMap( min(max(tvYI+rightPoint-r,1),row) , max(tvXI-r,1):min(tvXI+r,col) ) + 1;
  end  
  
  newPixelMap = pixelMap;

end