function signalMatrix = collectSignalsToMatrix(iv)
  numberOfSweep = iv.sweepnum;
  lengthOfSweep = length(iv.time);
  
  signalMatrix = zeros(numberOfSweep, lengthOfSweep);
  
  for i = 1 : numberOfSweep
    signalMatrix(i,:) = getIv(iv, i)';  
  end
end