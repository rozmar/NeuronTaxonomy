function [power, freq] = performFFT(signal, Fs)
  L = length(signal);
  n = 2^nextpow2(L);
  Y = fft(signal,n);
  freq = Fs*(0:(n/2))/n;
  power = abs(Y/n);
  power = power(1:n/2+1);
end