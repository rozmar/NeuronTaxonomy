

function plotCluster2D(X,idx,y,idxlabel,ylabel,ttl)
  figure; clf;
  hold on;
  title(ttl);
  plot(X(idx==idxlabel(1),1),X(idx==idxlabel(1),2),'ro','linewidth',1);
  plot(X(idx==idxlabel(2),1),X(idx==idxlabel(2),2),'bs','linewidth',1);
  plot(X(y==ylabel(1),1),X(y==ylabel(1),2),'ro','markerfacecolor','r','linewidth',1);
  plot(X(y==ylabel(2),1),X(y==ylabel(2),2),'bs','markerfacecolor','b','linewidth',1);
  hold off;
end