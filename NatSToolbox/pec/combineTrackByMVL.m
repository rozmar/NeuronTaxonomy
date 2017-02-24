% combineTrackByMVL group those consecutive units to a single track whose 
% MVLs' are above a given threshold.
% For each different track a unique track number will be assigned, units
% with NaN will get 0.
function [trackLabels,mvlByTrack,lengthByTrack] = combineTrackByMVL(meanVectors, parameters)

  %% --------------------------------
  %  Initialization
  %% --------------------------------
  trackLabels    = zeros(size(meanVectors));
  mvlByTrack     = zeros(size(meanVectors));
  lengthByTrack  = zeros(size(meanVectors));
  threshold      = parameters.threshold;
  mvlUntilNow    = NaN;
  trackLength    = 0;
  currentTrackID = 0;
  %% --------------------------------
  
  %% --------------------------------
  %  Process
  %% --------------------------------
  for position = 1 : length(meanVectors)
    
    % Get current cycle's MVL
    currLength = abs(meanVectors(position));
      
    % If the next cycle's MVL is NaN or too small
    if isnan(currLength) || currLength<threshold
      
      if trackLength>0
          
        % Save previous track
        [mvlByTrack(currentTrackID), lengthByTrack(currentTrackID), trackLength, mvlUntilNow] = ...
            deal(mvlUntilNow, trackLength, 0, NaN);
      end
        
      continue;
    end
    
    % If the length of the last track was 0
    if trackLength==0
            
      % Start new track
      [mvlUntilNow,trackLabels(position),currentTrackID,trackLength] = ...
          deal(currLength, currentTrackID+1, currentTrackID+1,1);
    else
    
      % Assign the current unit to the current track
      [trackLabels(position),trackLength] = ...
          deal(currentTrackID, trackLength+1);
      
      % Calculate new average mean vector length of this track
      mvlUntilNow = mean(abs(meanVectors(trackLabels==currentTrackID)));
      
    end
  end
  %% --------------------------------
  
  %% --------------------------------
  % If a valid cycle was the last
  %% --------------------------------
  if trackLength
      % Save properties of the last track
      [mvlByTrack(currentTrackID), lengthByTrack(currentTrackID)] = ...
            deal(mvlUntilNow, trackLength);
  end
  %% --------------------------------
  
  mvlByTrack(currentTrackID+1:end)    = [];
  lengthByTrack(currentTrackID+1:end) = [];
  
end

% Calculate the mean vector length of mean vectors
function newLength = meanOfMeans(meanVectors)
  newLength = circ_r(angle(meanVectors), abs(meanVectors));
end
