% findFollowedSegments Find those segments which are followed in a close
% interval with an event. The event and the "close" interval can be given
% in parameter.
%
% Parameters
%  - segmentStructure - structure contains the segment boundaries.
%  Mandatory fields
%    - start - sx1 vector, start times of segments
%    - end   - sx1 vector, end times of segments
%  - followerStructure - mx1 vector of events. Select those segments which
%  are followed with at least 1 follower event in a given interval
%  - parameters - parameter structure with the following mandatory fields
%     - followInterval - time in seconds in which the event has to occurr
%     to consider as "following". If the difference is the same as the
%     interval, it won't be included.
%     - mode - mode of search. It can be 
%             'follow' - event have to follow the segment (default)
%             'nofollow' - event cannot follow the segment 
% Return values
%  - followedInterval - nx1 logical vector what indicates which segments are
%  followed by an event
function followedIndex = findFollowedSegments(segmentStructure, followerVector, parameters)
  
  %% -------------------------
  %  Get parameters
  %% -------------------------
  nSegment = length(segmentStructure.start);
  fInterval = parameters.followInterval;
  
  if isfield(parameters, 'mode')
    if strcmpi(parameters.mode, 'nofollow')
      mode = 'without';
    elseif strcmpi(parameters.mode, 'follow')
      mode = 'within';
    end
  else
    mode = 'within';
  end
  
  %% -------------------------
  
  %% -------------------------
  %  Initialize
  %% -------------------------  
  afterSegment.start     = segmentStructure.end;
  afterSegment.end       = [segmentStructure.end]+fInterval;
  %% -------------------------  
  
  %% -------------------------
  %  Find following events
  %% -------------------------    
  followedIndex = findEventContainingSegment(afterSegment, followerVector, mode);
  %% -------------------------    
  
end