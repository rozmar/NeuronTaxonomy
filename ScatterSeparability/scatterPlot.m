function scatterPlot(X,y,ttl)

  colors = [ "b"; "r"; "g"; "m"; "y" ];

  clusters = unique(y);
  k = size(clusters,1);
  
  M_o = nanmean(X);
  
  figure(randi(1000),"visible","on");
  clf;
  hold on;
  
  for i=1:k
    X_i = X(y==clusters(i),:);
    mu_i = nanmean(X_i);
 
    if size(X,2)==1
      plot(X_i,ones(size(X_i,1),1).+i*0.02,[colors(clusters(i)+1),'o'],'markersize',10,'markerfacecolor',colors(clusters(i)+1));
      plot(mu_i,1,'ko','markerfacecolor','k');
      plot(M_o,1,'ko','markerfacecolor','k');
      ylim([-1 2]);
    elseif size(X,2)==2
      plot(X_i(:,1),X_i(:,2),[colors(clusters(i)+1),'o'],'markersize',10,'markerfacecolor',colors(clusters(i)+1));
      plot(mu_i(1),mu_i(2),'ko','markerfacecolor','k');
      plot(M_o(1),M_o(2),'ko','markerfacecolor','k');  	
    elseif size(X,2)==3
  	
    end
  end
  if nargin == 3 
    title(ttl);
  end
  hold off;
end