function answer = isMultiChannel(parameters)
  answer = isfield(parameters, 'analysis') && isfield(parameters.analysis, 'multiChannel') && parameters.analysis.multiChannel;
end