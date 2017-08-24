% collectEventsAroundMarker collects those events from the given vector
% which appears between the given markers.
%
% eventVector - vector of all event
% markers - 1x2 vector, where events have to be found
function eventTime = collectEventsBetweenMarker(eventVector, markers)
  eventTime = eventVector(markers(1)<=eventVector&eventVector<=markers(2));
end