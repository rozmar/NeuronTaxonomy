% combineTrackByMVD group those units to a single track whose MVDs'
% difference from the reference MVD is under the tolerance level.
% For each different track a unique track number will be assigned, units
% with NaN will get 0. The reference can be the first cycle or the average
% of the previous cycles'.
function [trackLabels,mvdByTrack,lengthByTrack] = combineTrackByMVD(meanVectors, parameters)

  %% --------------------------------
  %  Initialization
  %% --------------------------------
  trackLabels    = zeros(size(meanVectors));
  mvdByTrack     = zeros(size(meanVectors));
  lengthByTrack  = zeros(size(meanVectors));
  referenceAngle = NaN;
  trackLength    = 0;
  currentTrackID = 0;
  %% --------------------------------
  
  %% --------------------------------
  %  Parameter setting
  %% --------------------------------
  tolerance     = parameters.tolerance;
  referenceType = 'first';
  
  if isfield(parameters, 'referenceType')
    referenceType =  parameters.referenceType;
  end
  %% --------------------------------
  
  %% --------------------------------
  %  Process
  %% --------------------------------
  for position = 1 : length(meanVectors)
      
    % Get current cycle's MVD
    currAngle = toFullCirc(angle(meanVectors(position)));
      
    % If the next cycle is NaN
    if isnan(currAngle)
        
      % But the previous wasn't
      if ~isnan(referenceAngle)
          
        % Save previous track's properties
        [mvdByTrack(currentTrackID),lengthByTrack(currentTrackID)] = ...
            deal(referenceAngle, trackLength);
      end
        
      trackLength    = 0;
      referenceAngle = NaN;
      continue;
    end
    
    if isnan(referenceAngle)
        
      % If there wasn't previous track, start new
      [trackLabels(position), currentTrackID, referenceAngle, trackLength] = ...
          deal(currentTrackID, currentTrackID+1, currAngle, 1);
    else
      
      % Compare the difference to tolerance
      if abs(referenceAngle-currAngle) > tolerance
          
        % Save the properties of the previous track
        [mvdByTrack(currentTrackID),lengthByTrack(currentTrackID)] = ...
            deal(referenceAngle, trackLength);
        
        % Start new track
        [trackLabels(position), currentTrackID, referenceAngle, trackLength] = ...
          deal(currentTrackID, currentTrackID+1, currAngle, 1);
      else  
          
        % Assign the current cycle to the current track    
        [trackLabels(position), trackLength] = ...
          deal(currentTrackID, trackLength);
      
        % Update average reference angle
        if strcmpi(referenceType, 'avg')
          referenceAngle = updateReference(meanVectors, trackLabels, currentTrackID);
        end  
        
      end
      
    end
  end
  
  if ~isnan(referenceAngle)
      
    % Save the properties of the last track
    [mvdByTrack(currentTrackID),lengthByTrack(currentTrackID)] = ...
            deal(referenceAngle, trackLength);
  end
  
  mvdByTrack(currentTrackID+1:end)    = [];
  lengthByTrack(currentTrackID+1:end) = [];
  %% --------------------------------
 
end

% Calculate mean vector direction of mean vectors in a given track
function referenceAngle = updateReference(meanVectors, trackLabels, currentTrackID)
  thisTrackIdx   = (trackLabels==currentTrackID);
  thisTrackMV    = toFullCirc(angle(meanVectors(thisTrackIdx)));
  referenceAngle = toFullCirc(circ_mean(thisTrackMV));
end

% Convert angle from [-pi,pi] to [0,2pi]
function newAng = toFullCirc(oldAng)
  newAng = oldAng;
  negAng = (newAng<0);
  newAng(negAng) = newAng(negAng) + 2*pi; 
end