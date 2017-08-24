% Converts a value (vector, matrix, scalar) from deicbel scale to linear
% scale. It uses the definition of the decibel for conversion.
%
% Parameters
%  - inputValue - value on decibel scale which have to be converted
% Return value
%  - outputValue - the same value on linear scale
function outputValue = convertFromDecibel(inputValue)
  outputValue = 10.^(inputValue./10);
end