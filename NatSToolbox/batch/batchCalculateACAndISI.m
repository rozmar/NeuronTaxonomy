% batchCalculateACAndISI calculates autocorrelation and ISI for a given
% file for all required section. First, the sections will be converted to
% the specific format, then all event for each segment will be collected.
% After for each segment the AC and ISI was calculated, it will be plotted.
% 
% Parameters
%  inputStructure - input structure, which contains the events, section
%  boundaries, the trigger (if needed) and the name of the file
%  parameters - structure containing the processing and plotting parameters
% Return value
%  segmentStructure - structure which contains the segments: start and end
%  markers, plotting color, plot title, collected events and results
function segmentStructure = batchCalculateACAndISI(inputStructure, parameters)
  
  %% -------------------------
  %  Get segment boundaries
  %% -------------------------
  allEventSegment = createAllStructure(inputStructure, parameters);
  segmentStructure = collectSegments(inputStructure, parameters);
  segmentStructure = [allEventSegment , segmentStructure];
  %% -------------------------
  
  %% -------------------------
  %  Collect events in segment
  %% -------------------------
  evName      = parameters.event.name;
  eventVector = inputStructure.(evName).times;
  segmentStructure = collectEventsBySegment(eventVector, segmentStructure);
  %% -------------------------
  
  %% -------------------------
  %  Process each segment
  %% -------------------------
  nSegment = length(segmentStructure);
  for i = 1 : nSegment
    thisEvent                  = segmentStructure(i).eventVector;
    resultStruct               = calculateACAndISI(thisEvent, parameters);
    segmentStructure(i).result = resultStruct;
  end
  %% -------------------------
  
  %% -------------------------
  %  Plot the results
  %% -------------------------  
  plotACAndISI(segmentStructure, inputStructure.title, parameters);
  %% -------------------------
  
  %% -------------------------
  %  Save the results
  %% -------------------------    
  if parameters.isSave
      oDir  = parameters.output.dir;
      fName = inputStructure.title;
      oPath = sprintf('%s%s_ac_isi_result.mat', oDir, fName);
      save(oPath, 'segmentStructure');
  end
  %% ------------------------- 
  
end