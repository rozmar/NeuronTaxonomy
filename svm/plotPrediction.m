
function plotPrediction(X,y,p,model,featureList)
  C = X(y>1,:);
  if size(C,2)
    C = [ C ones(size(C,1),1) ];	
  end
  figure(randi(1000));
  clf;
  hold on;
  plotData(X(y<2,:),y(y<2));
  plotBoundary(model,[min(C(:,1)) max(C(:,1))]);
  plot(C(p==1,1),C(p==1,2),'ro');
  plot(C(p==-1,1),C(p==-1,2),'bo');
  hold off;	
end