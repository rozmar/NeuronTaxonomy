% generateMultiChannelStructure generates channel names from the template
% names for each parallel channel. If a channel name ends with underscore
% (_), it will be extended by the channel number (e.g. wideband_1,
% wideband_2 ...). If a channel name doesn't end with _, it will be the
% same for all channel (like spike channel).
% 
% Parameters
%  - parameters - parameter structure which has the following fields: 
%    - analysis.numOfChannel - number of parallel channel (should be at
%      least 2)
%    - channel - a structure which contains the name template for the
%      channels
% Return values
%  - channelStructureArray - nx1 structure array, where n is the number of
%    parallel channels
function channelStructureArray = generateMultiChannelStructure(parameters)

  %% -----------------------
  %  Initialize values
  %% -----------------------
  numberOfChannels = parameters.analysis.numOfChannel;
  baseStructure    = parameters.channel;
  channelTypes     = fieldnames(baseStructure);
  %% -----------------------
  
  %% -----------------------
  % Initialize new channel 
  % structure
  %% -----------------------
  channelStructureArray(1:numberOfChannels) = baseStructure;
  %% -----------------------
  
  %% -----------------------
  %  Generate channel names
  %% -----------------------
  for i = 1 : numberOfChannels
    for ch = 1 : length(channelTypes)
        
      thisChType = channelTypes{ch};
      thisChName = channelStructureArray(i).(thisChType).name;
        
      % Skip if this channel is common
      if isempty(regexpi(thisChName, '_$'))
        continue;
      end
      
      channelStructureArray(i).(thisChType).name = [thisChName,num2str(i)];
      
    end
  end
  %% -----------------------
end