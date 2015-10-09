
function V = backwardSearchBestCombination(X, features, iter, silent)
  %Check parameters. First two is mandatory
  if nargin < 3
    iter = 10;
    silent = 'off';
  elseif nargin < 4
    silent = 'off';
  end
  
  NQ = [];	%NextQueue
  
  for i=1:size(features,2)
    V(i).V=[];	
  end
  
  Q = features;	%initially, put all the features to the Queue
  
  while 1
  %loop through the elements in the queue
  for i = 1 : size(Q,1)
    f1 = Q(i,:);	%actual feature (f1)
    
    if strcmp(silent,'off')==1
      fprintf('Examine:\n');
      disp(f1);
    end
    
    if notIn(V(size(f1,2)).V,f1)	%if we don't examined this feature combination, put it to the V
      V(size(f1,2)).V = [ V(size(f1,2)).V ; f1 ];
    end
    
    possibleEdges = f1';	%features, which can be removed will be the potential edges
    
    %define an indicator matrix: M(i,j) is 1, if removing the jth feature in the ith iteration the new feature is better
    M = zeros(iter,size(possibleEdges,1));
    for j = 1 : size(possibleEdges,1)
      f2 = setdiff(f1,possibleEdges(j));	%create the new combination
      for i = 1 : iter
        M(i,j) = moreDimensionIsBetter(X,f1,f2,'mul');
      end
      %evaluate the indicator matrix: if m(j) is 1, in all iteration was the new combination is better
      m = mean(M(:,j));
      %if new combination was better than old in all iteration, 
      if m==1
        %put it in the next queue
        if notIn(NQ,f2)
          NQ = [ NQ ; f2 ];
        end
      end
    end
  end
  %NQ contains combinations which are better at least one larger old combination
  OldQ = Q;	%old combinations
  Q = [];	%new combination to examine
  for i = 1 : size(NQ,1)	%compare all of the new combination
    f2 = NQ(i,:);	%current new combination
    M = zeros(iter, size(OldQ,1));	%indicator matrix: M(k,j) is 1, if f2 was better than jth old combination in iteration k
    for j = 1 : size(OldQ,1) 	%with all of the old combination
      f1 = OldQ(j,:);		%old combination to compare
      for k = 1 : iter		%iterations
        M(k,j)= moreDimensionIsBetter(X,f1,f2,'mul');
      end
    end
    m = mean(M);		%how much time was it better
    if mean(m)==1		%if new combination is better than all old feature, we will examine it
      Q = [ Q ; f2 ];
    end
  end
  NQ = [];
  if size(Q,1)==0
    if strcmp(silent,'off')==1
      fprintf('No feature combination to examine. Quit.\n');
    end
    break;
  end
  
  if strcmp(silent,'off')==1
    fprintf('Remianed %d combination:\n',size(Q,1));
    disp(Q);
  end
  end	%while end
end
