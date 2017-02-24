 %% -----------------------------------
%  Categorize the given events (spikes) 
%  by the given boundaries.
%% -----------------------------------
function [occurence, patternArray] = categorizeFiringPattern(events, bounds)

  %% ---------------
  % No. of triggers
  % to categorize
  %% ---------------
  nTrigger = length(events);  
  %% ---------------

  %% ---------------
  % Preprocessing
  %% ---------------
  % Include the right boundary
  bounds(end) = bounds(end) + eps;
  % Create patterns
  [patternMask,patternArray]  = createPattern(length(bounds)-1);
  %% ---------------
  
  %% ---------------
  %  Calculate pattern
  %  occurences.
  %% ---------------
  nPattern  = length(patternArray);
  occurence = zeros(nPattern,1);
  for i = 1 : nTrigger
    thisEvents = events{i};
    
    % No. of events in bouts
    no = histc(thisEvents, bounds);
    no = no(1:end-1);
    
    if size(no,2)~=1
     no = no';
    end
    
    thisPattern = (no>0);
    mask = ismember(patternMask, thisPattern', 'rows');
    
    occurence(mask) = occurence(mask) + 1;
  end
  %% ---------------
  
end

%% ===================================
%  Create the patterns and pattern mask
%  for categorize firing. In parameter
%  the number of patterns have to be given.
%% ===================================
function [patternMask,patternArray] = createPattern(nBouts)

  %% ---------------
  %  Decide the number
  %  of patterns.
  %% ---------------
  nPattern = 1;
  
  for i = 1 : nBouts
    nPattern = nchoosek(nBouts, i); 
  end
  %% ---------------
  
  %% ---------------
  %  Generate patterns
  %% ---------------  
  patternArray = cell(nPattern, 1);
  patternMask  = false(nPattern, nBouts);
  j = 1;
  for i = 1 : nBouts
    patternVec = nchoosek(1:nBouts, i);
    for p = 1 : size(patternVec)
      patternArray{j} = patternVec(p,:);
      patternMask(j,patternVec(p,:)) = true;
      j = j + 1;
    end
  end
  patternArray{j} = [];
  %% ---------------  
    
end
%% ===================================