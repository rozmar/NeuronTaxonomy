% collectPsthMatrix collects the events around each given trigger and
% calculates their relative value.
function peritriggerEvents = collectPeritriggerEvents(triggerVector, eventVector, radius)

  %% -----------------------
  %  Initialization
  %% -----------------------
  nTrough = length(triggerVector);
  peritriggerEvents = cell(nTrough,1);
  %% -----------------------
    
  %% -----------------------
  %  Collect events around triggers
  %% -----------------------
  for i = 1 : nTrough
    peritriggerEvents{i} = collectEventsBetweenMarker(eventVector, radius + triggerVector(i)) - triggerVector(i);
  end
  %% -----------------------

end