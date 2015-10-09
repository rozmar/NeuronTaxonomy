function plotSeparatingFeatures(X,RS,y,odir,featureList)
  for i=1:2
    R = RS(i).R;
    for j=1:size(R,1)
      redNum = 1;
      blueNum = 0;
      F = X(:,R(j,1:end-2));
      
      if size(F,2)==1
        F = [ F ones(size(F,1),1) ];
      end
      
      [idx,c] = kmeans(F,2);
      
      name = [];
      for k=1:size(R,2)-2
        name = [ name , '-' , featureList{R(j,k)}];
      end
      
      plot2DClusterWithUnknown(F,c,idx,"off",y);
      %plot2DCluster(F,c,idx,"off");
      title(name);
      saveas(gcf,[odir,'/',num2str(i),'/',num2str(j),'-',name,'.png']);
    end
  end	
end