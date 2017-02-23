function [powerVector, frequencyVector] = performFFT(signal, parameters)

  % Calculate parameters for FFT
  sampleRate = parameters.samplingRate;
  
  % Get the number of points used for FFT
  if isfield(parameters, 'numberOfPoints')
    numberOfPoint = parameters.numberOfPoints;
  else
    numberOfPoint = 2^nextpow2(length(signal));
  end
  
  % Perform FFT
  fftCoeffs = fft(signal,numberOfPoint);
  % Calculate frequency values 
  frequencyVector = createFrequencyVector(numberOfPoint, sampleRate);
  
  % Calculate power from coefficients
  powerVector = abs(fftCoeffs / numberOfPoint);
  powerVector = powerVector(1:(numberOfPoint / 2) + 1).^2;
  
end

function freqVector = createFrequencyVector(numberOfPoint, sampleRate)
  halfOfPoint = numberOfPoint / 2;
  freqVector  = 0:halfOfPoint;
  freqVector  = sampleRate * freqVector;
  freqVector  = freqVector / numberOfPoint;
end