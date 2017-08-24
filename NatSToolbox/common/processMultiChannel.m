function [resultStructure,parameters] = processMultiChannel(processFunction, inputStructure, parameters)

  if ~isfield(parameters.analysis, 'multiChannel')||~parameters.analysis.multiChannel
    
    [resultStructure,parameters] = processFunction(inputStructure, parameters);
  else
    channelStructureArray = generateMultiChannelStructure(parameters);
    numOfChannels         = length(channelStructureArray);
    resultStructure       = [];
    for i = 1 : numOfChannels
      parameters.channel = channelStructureArray(i);
      [thisResultStruct,parameters] = processFunction(inputStructure, parameters);
      resultStructure = [resultStructure ; thisResultStruct ];
    end
  end

end