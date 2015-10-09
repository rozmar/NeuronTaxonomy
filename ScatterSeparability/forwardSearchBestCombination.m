
function V = forwardSearchBestCombination(X, features, iter, silent)
  
  if nargin<3
    iter = 10;
    silent = 'off';
  elseif nargin<4
    silent = 'off';
  end
  
  Q = [];	%current Queue
  NQ = [];	%Next Queue
  
  for i=1:size(features,2)
    V(i).V=[];	
  end
  
  Q = features';	%initially, we examine all feature alone
  
  while 1
    for i = 1 : size(Q,1)	%examine all of the elements in the queue
      f1 = Q(i,:);
      
      if strcmp(silent,'off')==1
        fprintf('Examine: ');
        disp(f1);
      end
     
     %collect the examined features in V
      if notIn(V(size(f1,2)).V,f1)==1
        V(size(f1,2)).V = [ V(size(f1,2)).V ; f1 ];
      end
        
      possibleEdges = setdiff(features,f1)';	%possible edges can be all of the other feature
      for j = 1 : size(possibleEdges,1)		%examine all of the new combinations
        f2 = union(f1, possibleEdges(j));
        M = zeros(iter,1);
        for k = 1 : iter	%try iter times
          M(k) = moreDimensionIsBetter(X, f1, f2, 'mul');
        end
        m = mean(M);	%m is 1, if in all iteration more dimension was better
        if m == 1
          if notIn(NQ, f2)==1
            NQ = [ NQ ; f2 ];
            disp(f2);
          end
        end	
      end	%end examine new combinations
    end	%end examine Q
    
    OldQ = Q;
    Q = [];
    Q = NQ;
    
    disp(NQ);
    
    if 0
    for i = 1 : size(OldQ,1)
      fprintf('Compare');
      f1 = OldQ(i,:);	%current new combination
      disp(f2);
      M = zeros(iter, size(NQ,1));
      for j = 1 : size(NQ,1)	%compare with all old feature
        f2 = NQ(j,:);
        for k = 1 : iter
          M(k,j) = moreDimensionIsBetter(X, f1, f2, 'mul');
        end
      end
      M
      m = mean(M)	%m(j) is 1, if ith new combination was better than jth old combination in all of the iterations
      if mean(m)==1	%if jth new combination was better than all of the old combination, we examine it further
        Q = [ Q ; f2 ];
      end
    end
    end
    
    NQ = [];
    
    if size(Q,1)==0
      if strcmp(silent,'off')==1
        fprintf('No more combination to examine. Exit.\n');	
      end
      break;
    end
    
    if strcmp(silent,'off')==1
      fprintf('%d new combination to examine:\n', size(Q,1));
      disp(Q);
    end
    
  end	%end while
end	%end function