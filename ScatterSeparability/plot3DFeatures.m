
function plot3DFeatures(X,features,idx,c,y)
  figure;
  clf;
  hold on;
  plot3(X(idx==1,features(1)),X(idx==1,features(2)),X(idx==1,features(3)),'ro','linewidth',1);
  plot3(X(idx==0,features(1)),X(idx==0,features(2)),X(idx==0,features(3)),'bo','linewidth',1);
  plot3(c(1,1),c(1,2),c(1,3),'ko','markerfacecolor','k');
  plot3(c(2,1),c(2,2),c(2,3),'ko','markerfacecolor','k');
  if nargin==5
    plot3(X(y==1,features(1)),X(y==1,features(2)),X(y==1,features(3)),'ro','linewidth',1,'markerfacecolor','r');
    plot3(X(y==0,features(1)),X(y==0,features(2)),X(y==0,features(3)),'bo','linewidth',1,'markerfacecolor','b');
  end
  hold off;
end