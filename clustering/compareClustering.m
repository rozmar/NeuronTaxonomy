


function avg = compareClustering(X,f1,f2)
  avg = 0;
  ID1 = [];
  ID2 = [];
  for i = 1 : 1000
    F1 = X(:,f1);
    F2 = X(:,f2);
    
    C1(1,:) = mean(F1)+(min(F1)/2);
    C1(2,:) = mean(F1)+(max(F1)/2);
    
    C2(1,:) = mean(F2)+(min(F2)/2);
    C2(2,:) = mean(F2)+(max(F2)/2);
    
    %[idx1] = kmeans(F1,2,'start',C1,'emptyaction','singleton');
    %[idx1] = kmeans(F1,2,'emptyaction','singleton');
    [idx1] = kmeans(F1,2,'start','uniform','emptyaction','singleton');
    %[idx2] = kmeans(F2,2,'start',C2,'emptyaction','singleton');
    %[idx2] = kmeans(F2,2,'emptyaction','singleton');
    [idx2] = kmeans(F2,2,'start','uniform','emptyaction','singleton');
    
    if size(ID1,1)>0 && mean(idx1'==ID1(1,:))<=0.5
      idx1 = repmat(3,size(idx1,1),1) - idx1;
    end
    
    ID1 = [ ID1 ; idx1' ];
 
    if size(ID2,1)>0 && mean(idx2'==ID2(1,:))<=0.5
      idx2 = repmat(3,size(idx2,1),1) - idx2;
    end
    
    ID2 = [ ID2 ; idx2' ];
  end
    
  idx1 = mode(ID1);
  idx2 = mode(ID2);
  
  MM1 = (ID1 == repmat(idx1,size(ID1,1),1));
  MM2 = (ID2 == repmat(idx2,size(ID2,1),1));
  
  probs1 = mean(MM1);
  mean(probs1);
  probs2 = mean(MM2);
  mean(probs2);
  
  avg = calculateDifference(idx1,idx2);
end