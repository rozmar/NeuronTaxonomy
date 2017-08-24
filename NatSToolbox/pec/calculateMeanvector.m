% calculateMeanvector calculates the resultant mean vector's length
% and direction for the given values and returns it in complex number
% representation.
%
% Parameters
%  values  - bx1 vector, values in segment binned into b bins
% Return value
%  resultant mean vector of the given data
function meanVector = calculateMeanvector(values)

  %% -----------------------
  %  Parameter setting
  %% -----------------------
  binNumber    = length(values);
  angleVector  = linspace(0, 360, binNumber+1);
  angleVector  = circ_ang2rad(angleVector(1:end-1))';
  %% -----------------------

  %% -----------------------
  %  Do the calculation
  %% -----------------------  
  rmean      = circ_r(angleVector,values);
  rphi       = circ_mean(angleVector,values);
  
  meanVector = rmean*exp(1i*rphi);
  %% -----------------------  
     
end