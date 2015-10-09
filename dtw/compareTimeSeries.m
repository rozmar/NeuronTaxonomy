function [dist] = compareTimeSeries(sweep1,sweep2,size)
  if nargin==3
    newSize=size;
  else
    newSize = (length(sweep1)+length(sweep2))/2;
  end
 
  sweep1res = resampleSweep(sweep1, newSize);
  sweep2res = resampleSweep(sweep2, newSize);
  
  sS1 = std(sweep1res);
  sS2 = std(sweep2res);
  
  sM1 = mean(sweep1res);
  sM2 = mean(sweep2res);
  
  sweep1res = ( sweep1res .- sM1 ) ./ sS1;
  sweep2res = ( sweep2res .- sM2 ) ./ sS2;
  
  plot(sweep1res,'b-');
  plot(sweep2res,'r-');
  
  [D, direction, trace ] = fillDTWMatrix(sweep1res, sweep2res, 1);

  dist=D(end,end);


end
