% findCorrectCycle find those cycles, where there isn't any event. The name
% of the cycle markers (trigger), cycle sections (section) and event
% markers (event) have to be given in parameter structure. The script
% creates a boolean mask to indicate where are the cycles.
%
% Parameters
%  inputStructure - structure which contains the required fields
%  parameters     - structure which contains the names' of the fields
%    signal - name of the signal channel, only the length of it needed
%    trigger - name of trigger channel, marks the cycles
%    triggerSection - name of section markers, only cycles between them are
%    considered
%    excludeevent - name of channel which discards the cycles
% Return value
%  correctCycleMask a boolean vector, its length is the same as the signal
%  length. Where it is true, there is valid cycle
function correctCycleMask = findCorrectCycle(inputStructure, parameters)

  %% ------------------------
  %  Get channel names
  %% ------------------------
  sigName = parameters.signal;         % signal chan. name
  sigChan = inputStructure.(sigName);          % signal chan.
  trName  = parameters.trigger;        % trigger chan. name
  secName = parameters.triggerSection; % section chan. name
  evName  = parameters.excludeevent;   % event chan. name
  %% ------------------------

  %% ------------------------
  %  Create section mask to
  %  avoid "outer" cycle
  %% ------------------------
  
  % The section mask will be the same length as the signal
  secMask      = false(size(sigChan.times));
  % Sample point neighbours
  edges        = sigChan.times - (sigChan.interval/2);
  edges        = [ edges ; edges(end)+sigChan.interval ];
  
  % Index of section start and end markers
  [~,secStIdx] = histc(inputStructure.([secName,'_st']).times, edges);
  [~,secEnIdx] = histc(inputStructure.([secName,'_end']).times, edges);
  
  % Mark section as true
  for i = 1 : length(secStIdx)
    secMask(secStIdx(i):secEnIdx(i)) = true; 
  end
  %% ------------------------  
  
  %% ------------------------  
  %  Create cycle mask (different
  %  number for each cycle)
  %% ------------------------  
  
  % The cycle mask will be the same length as the signal
  cycleMask = zeros(size(secMask));
  % Index of trigger marker
  [~,trInd] = histc(inputStructure.(trName).times, edges);
  
  % Give number to cycles
  for i = 1 : length(trInd)-1
    cycleMask(trInd(i):trInd(i+1)) = i; 
  end
  
  % Remove false cycles between sections
  cycleMask = cycleMask .* secMask;
  
  fprintf('%d\t| all cycle\n', length(unique(cycleMask(cycleMask>0))));
  %% ------------------------
  
  %% ------------------------  
  %  Remove cycle in which any
  %  event appear.
  %% ------------------------
  
  % Index of event markers
  [~,evInd] = histc(inputStructure.(evName).times, edges);
  
  % Cycle number with event in it
  dirtyCycleIndex = unique(cycleMask(evInd));
  
  % Remove those cycles where at least 1 event appears
  for i = 1 : length(dirtyCycleIndex)
    cycleMask(cycleMask==dirtyCycleIndex(i)) = 0; 
  end
  %% ------------------------
  
  % Convert mask to logical
  correctCycleMask = (cycleMask>0);
  
  % Print statistics
  fprintf('%d\t| cycle with event\n', length(dirtyCycleIndex));
  fprintf('%d\t| cycle remained\n',   length(unique(cycleMask(cycleMask>0))));
  
end