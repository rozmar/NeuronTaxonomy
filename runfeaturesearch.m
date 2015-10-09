
basedir = '/media/borde/Data/mdata/datasum';
projectName = 'HumanOedema';

load([basedir,'/',projectName,'/procMatrix_reduced.mat']);
load([basedir,'/',projectName,'/bestFeatures.mat']);

NX = procMatrix.NX;
un = [];

for i = 1 : size(bestFeatures,2)
  [~,idx] = deleteoutliers(NX(:,bestFeatures(i)));
  un = union(un,idx);
end

NX(un,:)=[];

for i = 1 : 10 
  L = backwardSearchBestCombinationNotStrict(NX,bestFeatures,100,'off');
  save(['/home/borde/Leaves_',num2str(i),'.mat'],'L');
end
