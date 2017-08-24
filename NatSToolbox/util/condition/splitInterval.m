%  splitInterval check the given intervals if they satisfie the following
%  rules and if not, convert them in appropriate form. The rules:
%    1. If interval is 1x2 vector and both values has the same sign, nothing
%    to do.
%    2. If interval is 1x2 vector but the values has different signs, split
%    the interval into 2 parts: before and after zero
%    3. If interval is scalar, it will be a symmetric interval and double 
%    it to the other side
% Before return, the values will be sorted in ascending order by their left
% edge.
function newCondition = splitInterval(conditions)

  %% -----------------------
  %  Initialization
  %% -----------------------
  nNewCondition = 0;
  nCondition    = length(conditions);
  %% -----------------------
  
  %% -----------------------
  %  Check each interval
  %% -----------------------  
  for i = 1 : nCondition
    thisCondition = conditions(i);
    interval      = sort(thisCondition.interval);
    
    % We don't examine the empty interval
    if isempty(interval)
      [nNewCondition,newCondition(nNewCondition)] = ...
          deal(nNewCondition + 1, thisCondition); %#ok<AGROW>
      continue;
    end
        
    % Double symmetrically interval
    interval = mirrorInterval(interval);
    
    % Split, if has different sign
    if sum(sign(interval))==0
       interval = [interval(1),0; ...
                   0 interval(2)];
    end
    
    % Put in output structure
    for j = 1 : size(interval,1)
      [nNewCondition,newCondition(nNewCondition)] = ...
          deal(nNewCondition + 1, thisCondition); %#ok<AGROW>
      
      % Set the new interval
      newCondition(nNewCondition).interval = interval(j,:); %#ok<AGROW>
    end
    
  end
  %% -----------------------
  
end