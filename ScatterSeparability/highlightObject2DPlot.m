function highlightObject2DPlot(X,features,idx,c,highlightIndex)
  groupcolor = {'b','r'};
  figure;
  clf;
  hold on;
  plot(X(intersect(highlightIndex,find(idx==1)),features(1)),X(intersect(highlightIndex,find(idx==1)),features(2)),'rs','linewidth',2,'markerfacecolor','r');
  plot(X(intersect(highlightIndex,find(idx==0)),features(1)),X(intersect(highlightIndex,find(idx==0)),features(2)),'bs','linewidth',2,'markerfacecolor','b');
  plot(X(idx==1,features(1)),X(idx==1,features(2)),'ro','linewidth',1);
  plot(X(idx==0,features(1)),X(idx==0,features(2)),'bo','linewidth',1);
  plot(c(1,1),c(1,2),'ko','markerfacecolor','k');
  plot(c(2,1),c(2,2),'ko','markerfacecolor','k');
  hold off;  
end