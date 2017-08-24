% cutSegments Cuts the given segments from the signal provided in parameter
% and returns them in an array.
% 
% Parameters
%  - signalStructure - structure contains the signal where we want to cut
%  from. It has to be at least 2 fields
%    - times  - nx1 vector, time for the signal
%    - values - nx1 vector, values of the signal
%  - segmentStructure - structure contains the segment boundaries.
%  Mandatory fields
%    - start - sx1 vector, start times of segments
%    - end   - sx1 vector, end times of segments
% Return value
%  - segmentedSignalArray - a cellarray which contains the segments of the
%  signal
function segmentedSignalArray = cutSegments(signalStructure, segmentStructure)

  %% -------------------------
  %  Get parameters
  %% -------------------------
  startVector = [segmentStructure(:).start]';
  endVector   = [segmentStructure(:).end]';
  
  time        = signalStructure.times;
  signal      = signalStructure.values;
  %% -------------------------
  
  %% -------------------------
  %  Initialize
  %% -------------------------
  nSegment             = length(startVector);
  segmentedSignalArray = cell(nSegment,1);
  %% -------------------------
  
  %% -------------------------
  %  Cut segments
  %% -------------------------
  for i = 1 : nSegment
    thisTime  = (startVector(i)<=time&time<=endVector(i));
    segmentedSignalArray{i} = signal(thisTime);
  end
  %% -------------------------
  
end