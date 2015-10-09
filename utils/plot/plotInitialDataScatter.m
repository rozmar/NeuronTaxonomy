function plotInitialDataScatter(X,y)
  figure;
  clf;
  hold on;
  plot(X(y==1,1),X(y==1,2),'ro');
  plot(X(y==0,1),X(y==0,2),'bo');
  hold off;
end