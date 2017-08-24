% createAllStructure Create a structure for the segment which contains all 
% event. The name of the channel which containins the events is specified 
% in parameter.
%
% Parameters
%  - inputStructure - input structure which contains at least a channel
%  with events
%  - parameters - parameter structure with following fields
%    - event.title - name of event channel
%    - event.name  - name of event channel
%    - all.color   - color assigned to "all event"
% Return value
%  - allStructure - a section structure containing all event
function allStructure = createAllStructure(inputStructure, parameters)

  %% ------------------------------
  %  Get parameters
  %% ------------------------------
  eventTitle = parameters.event.title;
  eventName  = parameters.event.name;
  %% ------------------------------
  
  %% ------------------------------
  %  Create structure
  %% ------------------------------
  allStructure.start = inputStructure.(eventName).times(1);
  allStructure.end   = inputStructure.(eventName).times(end);
  allStructure.title = sprintf('All %s',eventTitle);
  
  %  Set color 
  if isfield(parameters,'all') && isfield(parameters.all,'color')
    allStructure.color = parameters.all.color./255;
  else
    allStructure.color = [0,0,1]; 
  end
  %% ------------------------------
end