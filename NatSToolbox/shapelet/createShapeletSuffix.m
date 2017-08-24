
function suffix = createShapeletSuffix(filterVector, parameters)

  % Create suffix from filter values and plot mode
  suffix = strjoin({...
      filterToString(filterVector),...
      parameters.plot.clusterPlotMode},'_');
  
  % Clean from special characters the suffix
  suffix = regexprep(regexprep(suffix, '([\[\]]|(Hz))',''),'(,|\ )','_');
end