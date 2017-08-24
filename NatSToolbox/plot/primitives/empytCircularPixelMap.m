function pixelMap = empytCircularPixelMap(scale, resolution)
  x = linspace(-scale, scale, resolution+1);
  y = linspace(-scale, scale, resolution+1);
    
  inCircle = @(x,y)(x.^2 + y.^2)<=scale;
  
  pixelMap = zeros(resolution+1, resolution+1);
%   for i = 1 : resolution+1
%     for j = 1 : resolution+1
%       pixelMap(i,j) = 0;
%       if ~inCircle(x(i),y(j))
%         pixelMap(i,j) = NaN;
%       end
%     end
%   end
%   
end