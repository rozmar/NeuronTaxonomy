% This function get the sampling rate of a signal
function Fs = getFS(signalStructure)
  Fs = round(1/getSI(signalStructure));
end