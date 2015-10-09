

function examineOneClustering(X,bestFeatures,dim)
  runGetClustering('/media/borde/Data/mdata/datasum','.',dim);
  load(['Clusters_',num2str(dim),'.mat']);
  for i = 1 : 1000 ; 
    I = Clusters.Indexes(1).IND(i,:);
    if I(1)==2 ;
      I = repmat(3,1,size(I,2)).-I;
      Clusters.Indexes(1).IND(i,:)=I; 
    end;
  end;
  idx=mode(Clusters.Indexes(1).IND);
  MM = (Clusters.Indexes(1).IND==repmat(idx,size(Clusters.Indexes(1).IND,1),1));
  mM = mean(MM);
  fprintf('Billego:\n');
  find(mM<1)
  size(find(mM<1))
  Cl = [];
  cnt = [];
  matching = 0;
  for i = 1 : 1000 ;
    I = Clusters.Indexes(1).IND(i,:);
    for j = 1 : size(Cl,1)  ; 
      if mean(Cl(j,:)==I)==1 ;
        cnt(j)=cnt(j)+1;
        matching = 1;
        break; 
      end; 
    end;
    if matching==1; 
      matching=0; 
      continue;
    end; 
    Cl = [ Cl ; I ]; 
    cnt = [ cnt 1 ]; 
  end;
  cnt
end