


function Clusters = getClustering(X,l)

  d = size(X,2);	%dimension
    
  for k = 1 :  length(l)
    j = l(k);
    R = [];
    PM = makePermutation(d,j);
    fprintf('Calculating %d s\n',l(k));
    for i=1:size(PM,1)
    	
      Clusters(k).Indexes(i).IND = [];
      Clusters(k).Indexes(i).F = [];
    	
      fprintf('%d/%d\n',i, size(PM,1));
      F = X(:,PM(i,:));
      
      if sum(isnan(F))==size(F,1)
        R = [ R ; double(list(PM(i,:))) 0 ];
        continue;
      end
      
      Clusters(k).Indexes(i).F = PM(i,:);
      for c  = 1 : 1000
        %idx = kmeans(F,2,'emptyaction','singleton','start','uniform');
        idx = kmeans(F,2,'emptyaction','singleton');
        Clusters(k).Indexes(i).IND = [ Clusters(k).Indexes(i).IND ; idx' ];
      end
    end
    %save('Clusters.mat','Clusters');
  end
end
