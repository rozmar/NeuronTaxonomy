%Plots k-clustering of one feature.
%
% X - feature vector
% y - cluster assignments, can be in interval [1..10]
function plotKClusters2D(X,y,fn)
  symbols = ['r.';'b.';'g.';'k.';'c.';'m.';'rx';'bx';'gx';'bo'];

  k = size(unique(y),1);
  if nargin<3
    fn = k;
  end  
  figure(fn); clf;
  hold on;
  for i = 1 : k
    plot(X(y==i),ones(size(y(y==i))),symbols(i,:),'markersize',20);
  end
  hold off;
end