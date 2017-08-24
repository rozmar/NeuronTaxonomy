% mirrorInterval create a symmetric interval based on the interval radius.
% If parameter has two values, mirroring isn't needed.
% 
% Parameters
%  - interval - can come in two different forms
%    - 1x1 scalar, if only the radius was given to a symmetric interval
%    - 1x2 vector, if both ends of the interval was given, do nothing
% Return values
%  - mirroredInterval - 1x2 interval, the edges of interval
function mirroredInterval = mirrorInterval(interval)
  
  if length(interval)==1
    mirroredInterval = [-1,1]*interval; 
  else
    mirroredInterval = sort(interval);
  end
  
end