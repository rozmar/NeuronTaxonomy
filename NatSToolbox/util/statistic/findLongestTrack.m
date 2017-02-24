% findLongestTrack find the track length which belongs to the same
% category and decide which was the longest for each category.
function [lengthByCat,longestTrack] = findLongestTrack(categoryVector)

  %% -------------------------------
  %  Collect category labels
  %% -------------------------------
  categoryLabels = unique(categoryVector);
  nCategory = length(categoryLabels);
  %% -------------------------------
  
  %% -------------------------------
  %  Initialize data storage
  %% -------------------------------
  lengthByCat = cell(nCategory,1);
  lengthByCat(cellfun(@isempty, lengthByCat)) = {[]};
  %% -------------------------------
  
  %% -------------------------------
  %  Calculate track lengths
  %% -------------------------------
  position = 1;
  while ~isempty(position)
    thisCategory  = categoryVector(position);
    newTrack      = ((categoryVector-thisCategory)~=0);
    newTrackStart = find(newTrack(position:end),1,'first') + position - 1;
   
    if thisCategory==0
      position = newTrackStart;
      continue;
    end
    
    if isempty(newTrackStart)
      lengthByCat{thisCategory} = [ lengthByCat{thisCategory} , length(categoryVector)+1 - position ];
      break;
    else
      lengthByCat{thisCategory} = [ lengthByCat{thisCategory} , newTrackStart - position ];
    end
    
    position = newTrackStart;
    
  end
  longestTrack = cellfun(@max, lengthByCat);
  %% -------------------------------
  
end