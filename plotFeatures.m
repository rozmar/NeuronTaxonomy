
PM = makePermutation(length(featureMatrix),2);

for i = 1 : size(PM,1)
  F = X(:,featureMatrix(PM(i,:)));
  %IDX = [];
  %for j = 1 : 1000 
  % idx = kmeans(F,2,'emptyaction','singleton');
  % if idx(1)==2
  %   idx = ones(size(idx)).*3 .- idx;
  % end
  % IDX = [ IDX ; idx' ];
  %end
  %idx = mode(IDX);
  idx=WID(j,:);
  figure(i,'visible','on'); clf; hold on;
  plot(F(idx==1,1),F(idx==1,2),'ro','markersize',5,'linewidth',1);
  plot(F(idx==0,1),F(idx==0,2),'bs','markersize',5,'linewidth',1);
  plot(F(y==1,1),F(y==1,2),'ro','markersize',5,'linewidth',1,'markerfacecolor','r');
  plot(F(y==0,1),F(y==0,2),'bs','markersize',5,'linewidth',1,'markerfacecolor','b');
  title([featureList{featureMatrix(PM(i,1))},'-',featureList{featureMatrix(PM(i,2))}]);
  hold off;
  
  print(i,['/home/borde/',featureList{featureMatrix(PM(i,1))},'-',featureList{featureMatrix(PM(i,2))}],'-dsvg');
end