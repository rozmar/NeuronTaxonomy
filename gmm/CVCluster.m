function [NLS] = CVCluster(X,maxk)
  bestNL = -Inf;
  NL = 0;
  tempNL = 0;
  
  NLS = [];
  
  opt = statset('Display','final');
  
  [instnum,dim] = size(X);
  rndidx = randperm(instnum);
  RandX = X(rndidx,:);          %randomize instances
  foldSize = instnum/10;
  
  increased = true;
  clusterNum = 1;
  
  while(increased) 
    NL = 0;
    tempNL = 0;
    increased = false;
    for i = 1 : 10
      foldStart = 1+round((i-1)*instnum/10);
      foldEnd = round((i)*instnum/10);
      train = RandX([1:foldStart-1,foldEnd+1:end],:);
      test = RandX(foldStart:foldEnd,:);
      gm = gmdistribution.fit(train,clusterNum,'Regularize', 1e-5);
      
      tempNL = tempNL + (-1*gm.NlogL);
    end
    
    NL = tempNL / 10
    NLS(clusterNum) = NL;
    
    gm = gmdistribution.fit(X,clusterNum,'Regularize', 1e-5);
    
    %figure; clf; hold on; scatter(X(:,1),X(:,2),10,'ro'); ezcontour(@(x,y)pdf(gm,[x,y])); hold off; 
    if ( NL > bestNL ) 
      bestNL = NL;
      bestGM = gmdistribution.fit(X,clusterNum,'Regularize', 1e-5);
      increased = true;
      clusterNum = clusterNum + 1;
    end
    if (clusterNum >= maxk)
        break
    end
  end
  
  disp(num2str(clusterNum));
  bestGM
  
end