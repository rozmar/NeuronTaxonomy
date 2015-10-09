% Searches the best features combination.
%
% Searches the best features combination with forward tree building search.
% Takes features one by one, and expand them if it is better. Returns the 
% features which can't be improved.
function [Leaves] = forwardSearchBestCombinationNotStrict(X, features, iter, silent)

  %Check parameters. First two is mandatory
  if nargin < 3
    iter = 10;
    silent = 'off';
  elseif nargin < 4
    silent = 'off';
  end
  
  NQ = [];	%NextQueue
  
  for i=1:size(features,2)
    Leaves(i).F=[];	
  end
  
  Q = features';	%initially, put all the features to the Queue alone
  nans = [];
  
  for i = 1 : size(Q,1) 
      if sum(isnan(X(:,Q(i))))>0 
          nans = [ nans ; Q(i) ];
      end
  end
    
  while 1
  	
    %loop through the elements in the queue
    for i = 1 : size(Q,1)
      f1 = Q(i,:);	%actual feature (f1)
      hasAnyChild = 0;
      if sum(ismember(nans,f1))>0
          continue;
      end
      
      if strcmp(silent,'off')==1
        fprintf('Examine:\n');
        disp(f1);
        %fflush(stdout);
        drawnow('update');
      end
    
      if size(f1,2)==size(features,2)       %if the current feature set is maximal, we don't have to examine
        if notIn(Leaves(size(f1,2)).F,f1)	%if we don't examined this feature combination, put it to the V
            Leaves(size(f1,2)).F = [ Leaves(size(f1,2)).F ; f1 ];
        end	
        continue;
      end
        
      possibleEdges = setdiff(features,f1)';	%features, which can be added will be the potential edges
    
      %define an indicator matrix: M(i,j) is 1, if adding the jth feature in the ith iteration the new feature is better
      M = zeros(iter,size(possibleEdges,1));
      for j = 1 : size(possibleEdges,1)
        f2 = union(f1,possibleEdges(j))	%create the new combination
        if sum(ismember(nans,f2))>0
          continue;
        end
        for i = 1 : iter
          M(i,j) = moreDimensionIsBetter(X,f1,f2,'mul','upward');
        end
        %evaluate the indicator matrix: if m(j) is 1, in all iteration was the new combination is better
        m = mean(M(:,j));
        %if new combination was better than old in all iteration, 
        if m==1
          %put it in the next queue
          hasAnyChild = 1;
          if notIn(NQ,f2)
            NQ = [ NQ ; f2 ];
          end
        end
      end
    
      if hasAnyChild==0
        if notIn(Leaves(size(f1,2)).F,f1)	%if we don't examined this feature combination, put it to the V
          Leaves(size(f1,2)).F = [ Leaves(size(f1,2)).F ; f1 ];
        end	
      end 
    end
    
    Q = NQ;  		%enqueue the children to examination
    NQ = [];		%empty the working queue
  
    if size(Q,1)==0	%if no more feature combination remained to examine
      if strcmp(silent,'off')==1
        fprintf('No feature combination to examine. Quit.\n');
      end
      break;
    end
    
    if strcmp(silent,'off')==1
      fprintf('Remianed %d combination:\n',size(Q,1));
      disp(Q);
    end
    %fflush(stdout);
    drawnow('update');
  end	%while end
  
  %At this point, we have the trace of a tree. Leaves of the tree are those combination which cannot be improved with subtracting more feature.
  %We compare the leaves which is the best. 
  
 
end	%function end
