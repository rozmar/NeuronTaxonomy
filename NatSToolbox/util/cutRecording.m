% cutRecording trim every time vector in a structure to the given interval.
%
% cutStruct = cutRecording(initialStructure, cutInterval, fieldNameArray)
%   - initialStructure original structure to trim
%   - cutInterval 1x2 vector, the boundaries for the remaining interval
%   - fieldNameArray array of fields to cut
% cutStruct new structure with trimmed channels
function cutStruct = cutRecording(initialStructure, cutInterval, fieldNameArray)
      
  cutStruct = initialStructure;
      
  if nargin<3 || isempty(fieldNameArray)
    fieldNameArray = fieldnames(initialStructure); 
  end
  
  for i = 1 : length(fieldNameArray)
    thisField = fieldNameArray{i};
    
    if ~isstruct(cutStruct.(thisField))
      continue;
    end
    
    thisTime = cutStruct.(thisField).times;
    cutIndex = (cutInterval(1)<=thisTime&thisTime<=cutInterval(2));
    if isfield(cutStruct.(thisField),'values')
      cutStruct.(thisField).values = cutStruct.(thisField).values(cutIndex);
    end
    cutStruct.(thisField).times = thisTime(cutIndex);
  end
    
end