

function Diff = calculateDifferencesForClustering(X,V,indstart,featureSet)
  for i=1:length(V)
    Diff(i).V = [];	
  end
  ind = indstart;
  %printf("Processing %d combination.\n", size(V(ind).V,1));
  for i = 1 : size(V(ind).V,1)
    %printf("First combination: \n"); 
    %disp(V(ind).V(i,:));
    VSet = [V(ind).V(i,:)];
    VSetNew = [];
    while size(VSet,1)>0  
      f1 = VSet(1,:);
      VSet(1,:) = [];
      potentialFeatures=setdiff(featureSet,f1);
      for j=1:size(potentialFeatures,2)
        f2 = union(f1,potentialFeatures(j));
        
        if notIn(V(ind+1).V,f2)
          continue;
        end
        
        if ~notIn(VSetNew,f2)
          continue
        end
               
        %printf("Examine: \n");
        %disp(f2);
        
        avg = compareClustering(X,f1,f2);
        
        VSetNew = [ VSetNew ; f2 ];
        Diff(ind+1).V = [ Diff(ind+1).V ; f2 avg ];
      end
      if size(VSet,1)==0
        ind = ind+1;
        VSet = VSetNew;
        VSetNew = [];
      end
      if ind==length(V)
        break;
      end
    end
    ind = indstart;
  end
end