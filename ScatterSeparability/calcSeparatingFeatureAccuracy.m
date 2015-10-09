function accuracies = calcSeparatingFeatureAccuracy(X,RS,y,odir)
  for i=1:length(RS)
    R = RS(i).R;
    miss = [];
    fprintf('%d s\n',i);
    for j=1:size(R,1)
      fprintf('%d/%d\n',j,size(R,1));
      F = X(:,R(j,1:end-1));
      m = [];
      for k = 1 : 10
      
        [idx,c] = kmeans(F,2,'emptyaction','singleton');
      
        idx(idx==2)=0;
      
        cfm = calcConfusionMatrixClustering(F,idx(y<2),y(y<2));
        
        m = [ m ; cfm ];
      end
      
      m = mode(m);
      
      miss = [ miss ; R(j,1:end-1) m ];
    end
    accuracies(i).miss = miss;
    save([odir,'/miss.mat'],'accuracies');
  end		
end