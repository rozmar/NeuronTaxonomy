Bests = {};

for i = 1 : length(Lee)
 
  for j = 1 : size(Lee(i).F,1)
    f = Lee(i).F(j,:);
    F = NX_sub(:,f);
    nans = [];
    for l = 1 : size(F,2)
      nans = union(nans, find(isnan(F(:,l))));
    end
    F(nans,:) = [];
    y_orig = y_sub;
    y_sub(nans,:)=[];
    CFM = [];
    
    for k = 1 : 100
      idx = kmeans(F,2,'emptyaction','singleton');
      if idx(1)==2
        idx = ones(size(idx)).*3 - idx;
      end
      idx(idx==2)=0;
      %CFM = [ CFM ; calcConfusionMatrixClustering(NX,idx(y_sub<2),y_sub(y_sub<2)) ];

      CFM = [ CFM ; calcConfusionMatrixClustering(NX,idx,y_sub) ];
    end
    fprintf('Feature: ');
    disp(f);
    %fflush(stdout);
    drawnow('update');
    miss = sum(mean(CFM(:,2:3)));
    fprintf('%f\n',miss);
    if miss==0
      Bests{length(Bests)+1} = f;
    end
    y_sub=y_orig;
  end
end
