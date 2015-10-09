
function plotOnHistograms(X,features,y,figureNum)

  for i = 1 : length(features)
    F = X(:,features(i));
    F = F(~isnan(F),:);
    range = max(F)- min(F);
    x = [];
    for j = 1 : 10
      x(j) = min(F) + ((j-1)*range/10);
    end
    IDX = [];
    for j = 1 : 1000 
     idx = kmeans(F,2,'emptyaction','singleton');
     if idx(1)==2
       idx = ones(size(idx)).*3 .- idx;
     end
     IDX = [ IDX ; idx' ];
    end
    idx = mode(IDX);
    
    if nargin < 4
      figureNum = i;
    end
    
    figure(figureNum); clf; hold on;
    hist(F(idx==1),x,'facecolor','w','edgecolor','r','linewidth',1);
    hist(F(idx==2),x,'facecolor','w','edgecolor','b','linewidth',1);
    hist(F(y==1),x,'facecolor','r','edgecolor','r','linewidth',1);
    hist(F(y==0),x,'facecolor','b','edgecolor','b','linewidth',1);
    hold off;
  end

end