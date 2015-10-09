


function Diff = calculateDifferencesForClusteringDown(X,VStart,indstart)
  for i=1:indstart
    Diff(i).V = [];	
    V(i).V = [];
  end
  ind = indstart;
  printf("Processing %d combination.\n", size(V(ind).V,1));
  for i = 1 : size(VStart,1)
    printf("First combination: \n"); 
    disp(VStart(i,:));
    VSet = [VStart(i,:)];
    VSetNew = [];
    while size(VSet,1)>0  
      f1 = VSet(1,:);
      VSet(1,:) = [];
      potentialFeatures=f1;
      for j=1:size(potentialFeatures,2)
        f2 = setdiff(f1,potentialFeatures(j));
        if ~notIn(VSetNew,f2)
          continue
        end
        
        printf("Examine: \n");
        disp(f2);
        
        avg = compareClustering(X,f1,f2);
        
        VSetNew = [ VSetNew ; f2 ];
        Diff(ind-1).V = [ Diff(ind-1).V ; f2 avg ];
      end
      if size(VSet,1)==0
        ind = ind-1;
        VSet = VSetNew;
        VSetNew = [];
      end
      if ind==1
        break;
      end
    end
    ind = indstart;
  end
end
