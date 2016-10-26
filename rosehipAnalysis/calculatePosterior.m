function PMatrix = calculatePosterior(dataMatrix, classVector)
  classLabels = unique(classVector);
  nClass = length(classLabels);
  nDim   = size(dataMatrix,2);
  gModels = cell(nClass,1);
  mixP    = zeros(nClass,1);
  mus     = zeros(nClass, nDim); 
  
  for c = 1 : nClass
    gmm = gmdistribution.fit(dataMatrix(classVector==c,:), 1);
    
    mixP(c) = sum(classVector==c);
    mus(c,:) = gmm.mu;
    sigmas(:,:,c) = gmm.Sigma;
    
  end
  
  mixP = mixP./length(classVector);
  
  globalGmm = gmdistribution(mus, sigmas, mixP);
  PMatrix   = globalGmm.posterior(dataMatrix);
  
  x = sort(dataMatrix(:,1));
  y = sort(dataMatrix(:,2));
  
  [X,Y] = meshgrid(x,y);
  gmmPdf = globalGmm.pdf([X(:),Y(:)]);
  gmmPdf = reshape(gmmPdf, length(y), length(x));
  
  figure;
  pcolor(x, y, gmmPdf);
  colormap jet;
  shading interp;
  
end