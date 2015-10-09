

function [D, direction, trace ] = fillDTWMatrix(sweep1, sweep2, w)
  D = zeros(length(sweep1)+1,length(sweep2)+1)+Inf;
  D(1,1)=0;
  direction = zeros(length(sweep1),length(sweep2));
   
  for i = 2 : length(sweep1)+1
    for j = max(i-w,2) : min(i+w,length(sweep2)+1)
      minimalDist = min ( [D(i-1,j), D(i-1,j-1), D(i,j-1)] );
      D(i,j) = cost(sweep1(i-1),sweep2(j-1)) + minimalDist;
      if minimalDist == D(i-1,j)
        direction(i,j) = 1;
      elseif minimalDist == D(i-1,j-1)
        direction(i,j) = 11;
      else
        direction(i,j) = 10;
      end
    end
  end
  trace = zeros(size(sweep1));
  i = length(sweep1)+1;
  j = length(sweep2)+1;
  
  while j > 1
    trace(j) = i-1;
    tenth = direction(i,j)/10;
    if floor(tenth)==1
      j = j-1;
    end
    if floor(tenth)~=tenth
      i = i-1;
    end
    
  end
  
  trace = [ (1:1:length(sweep1)) ; trace(2:end) ]';
  
end