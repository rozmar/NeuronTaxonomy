% Converts a value (vector, matrix, scalar) to deicbel scale from linear
% scale. It uses the definition of the decibel for conversion.
%
% Parameters
%  - inputValue - value on decibel scale which have to be converted
% Return value
%  - outputValue - the same value on linear scale
function outputValue = convertToDecibel(inputValue)
  outputValue = 10.*log10(inputValue); 
end