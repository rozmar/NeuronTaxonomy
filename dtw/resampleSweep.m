% This function resamples a one dimensional time series.
% It expects two parameters:
% - the original sweep which have to be resampled
% - the length of the resampled sweep
% It returns the resampled sweep.
function resampled = resampleSweep(sweep, newlength)
  
  oldlength = length(sweep);                          %get original length
  sampleRate = (oldlength-1) / (newlength-1);  %calculate the resampling rate
  
  j = 1.0;    %index of the old sweep (if it is a fraction, it have to be interpolated)
  for i = 1 : newlength %indexes of the new sweep
    lambda = j - floor(j);  %proportion of the left end
    oneMinusLambda = 1.0 - lambda;  %proportion of the right end
    
    left = sweep(floor(j)); %left end
    
    %get the right end. 
    if ceil(j)>=oldlength
      right = sweep(end);
    else
      right = sweep(ceil(j));
    end
    
    resampled(i) = lambda*left + oneMinusLambda*right;    %calculate the new point
    
    j = j + sampleRate;
    
  end
  
end