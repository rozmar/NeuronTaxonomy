
%featureMatrix = WF6;
%featureMatrix = b;
iter = 1000;

for i = 1 : size(featureMatrix,1)

  w = featureMatrix(i,:);
  W = NX_sub(:,w);
  WID = [];
  GMS = {};
  C = {};
  cnt = [];
  for j = 1 : iter
    if strcmp(clusterMode,'GMM')
        opt = statset('MaxIter',500);
        gm = gmdistribution.fit(W,2,'Options',opt,'Regularize',1e-5);
        idx = cluster(gm,W);
    elseif strcmp(clusterMode,'KM')
        [idx,c] = kmeans(W,2,'emptyaction','singleton','Display','off');
    end
    idx(idx==2)=0;
    if idx(1)==0
      idx = ones(size(idx)) - idx;
    end
    if size(WID,1)==0
        im = [];
    else
        [im, id] = ismember(WID,idx','rows');
    end
    fflush(stdout);
    %drawnow('update');
    if size(im,1)==0 || sum(im)==0
      WID = [ WID ; idx' ];
      cnt = [ cnt ; 1 ];
      if strcmp(clusterMode,'KM')
        C{length(C)+1}.c = c;
      else
          GMS{length(GMS)+1}.gm = gm;
      end
    else
      cnt(find(id==1)) = cnt(find(id==1))+1;
    end
  end
  if size(WID,1)==1
    mw = WID;
  else
    mw = mode(WID);
  end
  MM = ( WID == (ones(size(WID,1),1)*mw) );
  mmm = mean(MM);
  fprintf('With featres ');
  disp(w);
  fprintf(' number of inconsistent cell: %d\n', size(find(mmm<1),2));
  fprintf('%d cluster assignment got\n', size(WID,1));
  for k = 1 : size(WID,1)
    fprintf('%d clustering: %f%%\n', k, cnt(k)*100/iter);
  end
end
