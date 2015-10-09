
function highlightObject3DPlot(X,features,idx,c,H)
  figure;
  clf;
  hold on;
  plot3(X(idx==1,features(1)),X(idx==1,features(2)),X(idx==1,features(3)),'ro','linewidth',1);
  plot3(X(idx==0,features(1)),X(idx==0,features(2)),X(idx==0,features(3)),'bo','linewidth',1);
  plot3(c(1,1),c(1,2),c(1,3),'ko','markerfacecolor','k');
  plot3(c(2,1),c(2,2),c(2,3),'ko','markerfacecolor','k');
  plot3(H(:,1),H(:,2),H(:,3),'go','markerfacecolor','g','linewidth',1);
  hold off;  
end