function plotOnHistogramsCombined(X,features,y,idx,featureList,figureNum)

  for i = 1 : length(features)
    F = X(:,features(i));
    F = F(~isnan(F),:);
    range = max(F)- min(F);
    x = [];
    for j = 1 : 10
      x(j) = min(F) + ((j-1)*range/10);
    end
    
    if nargin < 6
      figureNum = i;
    end
    
    figure(figureNum); clf; hold on;
    title(featureList{features(i)});
    hist(F(idx==0),x,'facecolor','w','edgecolor','b','linewidth',1);
    hist(F(idx==1),x,'facecolor','w','edgecolor','r','linewidth',1);
    hist(F(y==0),x,'facecolor','b','edgecolor','b','linewidth',1);
    hist(F(y==1),x,'facecolor','r','edgecolor','r','linewidth',1);
    hold off;
  end

end