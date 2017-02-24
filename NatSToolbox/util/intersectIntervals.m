% intersectIntervals decompose intervals which contain smaller
% interval(s) with opposite marker. Itervals should not partially 
% intersect each other, because it can cause unexpected result. 
% If each interval disjoint or has the same marker, nothing will be
% changed.
%
% Parameters
%  - intBounds - ix2 matrix, contains i interval's start and end values.
%    Intervals can conatain each other, but shouldn't intersect partially
%    each other, because it will cause inappropriate result.
%  - intMarker - ix1 vector, contains 0 or 1 markers. 
% Return value
%  - borderMatrix - mx3 matrix, the edges of the new intervals
%  - typeVector  - mx1 vector, the markers of the new intervals
function [borderMatrix,typeVector] = intersectIntervals(intBounds, intMarker)

  %% ---------------------------
  %  In case of 1 interval, or
  %  each interval has the same 
  %  type, there is nothing to do.
  %% ---------------------------
  nInterval = size(intBounds,1);
  if nInterval==1 || allTheSame(intMarker)
    borderMatrix = intBounds;
    typeVector   = intMarker;
    return;
  end
  %% ---------------------------

  %% ---------------------------
  %  Form input data
  %% ---------------------------
  %  Number of interval border
  nBound    = nInterval*2;
  %  Type of edges: 1 - begin, -1 end
  endType   = repmat([1;-1],nInterval,1);
  %  Value of edges (vector form)
  intBounds = reshape(intBounds', nBound, 1);
  %  Type of marker by edge
  markers   = reshape((intMarker * [1,1])', nBound, 1);
  %% ---------------------------  
  
  %% ---------------------------
  %  Sort edges
  %% ---------------------------  
  [~,sidx]     = sort(intBounds);
  sortedBounds = [ intBounds(sidx)' ; ...
                   endType(sidx)' ; ...
                   markers(sidx)' ];
  %% ---------------------------  
  
  %% ---------------------------
  %  Decompose intersected interval
  %% ---------------------------    
  borderMatrix = [];
  typeVector   = [];
  stack        = [];
  for i = 1 : nBound
    
    % If this edge is the start of an interval
    if isOpening(sortedBounds(2,i))
      
      % Every time we open a new interval, we have to put 
      % it into the stack, regardless the state of stack.
      stack = putStack(stack, sortedBounds(1,i)); 
        
      % If the stack contains 
      % only the current start
      if length(stack)==1
          
        % We can set interval type 
        %to the current one
        currentType = sortedBounds(3,i);
        
        % and move forward
        continue;
        
      % If there was an already opened interval
      elseif length(stack)>=2                   

        % Remove the previous element from stack
        toSave  = stack(end-1);
        
        % Save the type of the interval
        % then invert it
        lastType    = currentType;
        currentType = switchType(lastType); 
      end
      
    else
      
      % This is an interval ending edge
      % We will close the last interval
      % And empty the stack
      toSave = stack(end);
      lastType = currentType;
      
      % If we had two opened interval,
      % 
      if length(stack)>=2
        % switch back interval type
        currentType = switchType(lastType); 
        stack       = [stack(1:end-1);sortedBounds(1,i)];
      else
        stack       = [];
      end
    end
    
    %% ---------------------
    % Save the last interval
    %% ---------------------
    borderMatrix = ...
        appendTo(borderMatrix, [toSave , sortedBounds(1,i)]);    
    typeVector   = ...
        appendTo(typeVector,   lastType);
    %% ---------------------
    
  end
  %% ---------------------------
  
end

% Each element of the vector is the same.
function answer = allTheSame(vector)
  answer = (sum(vector-vector(1))==0);
end

% Determine if an interval edge is opening or closing edge
function answer = isOpening(edgeType)
  answer = (edgeType==1);
end

% Helper function: append the given value to the given vector/matrix
function newStructure = appendTo(oldStruct, newValues)
  newStructure = cat(1, oldStruct, newValues);
end

% Invert interval type: 0 to 1, 1 to 0
function newType = switchType(oldType)
  newType = 1-oldType;
end

% Put element to the end of stack
function newStack = putStack(oldStack, value)
  newStack = cat(1, oldStack, value);
end