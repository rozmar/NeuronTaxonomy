

function runGetClustering(inputdir, outputdir, dim)
  %NX = load([inputdir,"/procMatrix.mat"]).procMatrix.NX;
  load([inputdir,"/FNX.mat"]);
  bestFeatures = load([inputdir,"/bestFeatures.mat"]).bestFeatures;
  %F = NX(:,bestFeatures);
  F = FNX(:,bestFeatures);
  F(110,:)=[];
  Clusters = getClustering(F, dim);
  save([outputdir,"/Clusters_",num2str(dim),".mat"]);
end
