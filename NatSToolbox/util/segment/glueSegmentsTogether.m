% glueSegmentsTogether deletes everything between the segment separators.
% We can give one or more channels in parameter which will be cut and glued.
% Besides that, we have to give a separator matrix, which contains the 
% desired segments' start and end times, and the "edgeVector" for the event 
% train creation. If a channel is a waveform channel, deletes
% every value outside the segments, so "deletes" them. If a channel
% is event channel, events outside the segments will be eliminated.
%
% Parameters
%   inputStructure - a structure with one or more structure fields. Every
%   structure in it has to contain at least a times field, and and additional
%   values field (if it is a waveform channel).
%   segmentingMatrix - sx2 matrix, where s is the number of segments, and
%   each row contains the start and end of the given segment
%   edgeVector - tx1 vector, which contains every sample point in the
%   recording. It will be used for the creation of the event trains.
% Return values
%   outputStructure has the same structure as the input, only the values will
%   be the new values
function outputStructure = glueSegmentsTogether(inputStructure, segmentingMatrix, edgeVector)

  %% -------------------------------
  % Initialization
  %% -------------------------------
  outputStructure     = inputStructure;
  channelNames        = fieldnames(outputStructure);
  nChannel            = length(channelNames);
  SI                  = diff(edgeVector([1,2]));
  %% -------------------------------
  
  %% -------------------------------
  % Find separator indices
  %% -------------------------------
  [segmentStartIdx, segmentEndIdx] = findSegmentPoint(edgeVector, segmentingMatrix);
  nSeparator          = length(segmentStartIdx);
  %% -------------------------------

  %% -------------------------------
  % Create mask vector
  %% -------------------------------
  maskBySegment = cell(nSeparator,1);
  for i = 1 : nSeparator
    maskBySegment{i} = (segmentStartIdx(i):segmentEndIdx(i))'; 
  end
  maskIndex = cell2mat(maskBySegment);
  
  segmentMask            = false(length(edgeVector),1);
  segmentMask(maskIndex) = true;
  newTimePoint           = sum(segmentMask);
  newTimeVector          = linspace(0,(newTimePoint-1)*SI,newTimePoint)';
  %% -------------------------------
  
  %% -------------------------------
  % Cut out the slices between
  % separators
  %% -------------------------------
  for c = 1 : nChannel
    thisChannel = outputStructure.(channelNames{c});
    
    if isfield(thisChannel, 'values')
      thisChannel.values(~segmentMask(1:end-1)) = [];
      thisChannel.times                         = newTimeVector;
    else
      thisTime                          = thisChannel.times;
      eventTrain                        = logical(histc(thisTime, edgeVector));
      eventTrain(~segmentMask(1:end-1)) = [];
      thisChannel.times                 = newTimeVector(eventTrain);
    end
    outputStructure.(channelNames{c}) = thisChannel;
    
  end
  %% -------------------------------
  
  
end

function [segmentStartIdx, segmentEndIdx] = findSegmentPoint(edgeVector, segmentingMatrix)
  [~,segmentStartIdx] = histc(segmentingMatrix(:,1), edgeVector);
  [~,segmentEndIdx]   = histc(segmentingMatrix(:,2), edgeVector);
  
  toRemoveIndex = (diff([segmentStartIdx,segmentEndIdx]')'==0);
  
  segmentStartIdx(toRemoveIndex) = [];
  segmentEndIdx(toRemoveIndex) = [];
end