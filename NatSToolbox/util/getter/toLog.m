% toLog decides if logging to csv file is enabled or not
function answer = toLog()
  global logFile;
  answer = (logFile~=-1);
end