% createPeritriggerSegment creates a segment structure which represent
% interval around a trigger vector. This script creates a segmentStructure
% which can be used in other scripts. Trigger title and color can be given
% for firing histogram (ACF, ISI). If only the section needed, the
% makePeriTriggerMarker should be used instead.
%
% Parameters
%  - triggerVector - nx1 vector contains the reference markers
%  - parameters - parameter structure with following fields
%    - analysis.radius - interval around the trigger
%    - channel.trigger.title (optional) - title of the trigger, will be
%    used at the title of segment
%    - plot.palette (optional) - individual color can be given, else blue
%    will be used
% Return value
%  - periTriggerStructure - section structure which contains the section
%  start and end, a title and a color.
function periTriggerStructure = createPeritriggerSegment(triggerVector, parameters)
  
  %% ----------------------------
  %  Create result structure from 
  %  the given triggers and the
  %  given analysis radius.
  %% ----------------------------
  periTriggerStructure = makePeriTriggerMarker(triggerVector, parameters.analysis.radius);
  %% ----------------------------
  
  %% ----------------------------
  %  If title was given, set it to
  %  the segment structure. Else,
  %  set default value as empty.
  %% ----------------------------
  if isfield(parameters,'channel')&&isfield(parameters.channel,'triggerTitle')
    periTriggerStructure.title = sprintf('Around %s (%.1fms)',  parameters.channel.triggerTitle, parameters.analysis.radius*1000);    
  else
    periTriggerStructure.title = '';
  end
  %% ----------------------------
  
  %% ----------------------------
  %  If color was given, set the
  %  color to the segment. Else,
  %  use default blue color.
  %% ----------------------------
  if isfield(parameters,'plot')&&isfield(parameters.plot,'palette')
    periTriggerStructure.color = parameters.plot.palette.fc;    
  else
    periTriggerStructure.color = [0,0,1];
  end
  %% ----------------------------
  
end