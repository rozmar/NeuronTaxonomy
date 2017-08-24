% shiftWithScalar shifts a nx1 vector with a given scalar.
% 
% Parameters
%  - initialVector - nx1 vector, the original vector
%  - scalar - 1x1 scalar, with which we want to shift the vector
% Return values
%  - newVector - nx1 vector, vector with shifted values
function newVector = shiftWithScalar(initialVector, scalar)
  shiftVector = ones(size(initialVector)) .* scalar;
  newVector = initialVector + shiftVector;
end