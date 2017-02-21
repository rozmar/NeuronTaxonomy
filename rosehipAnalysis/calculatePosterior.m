function PMatrix = calculatePosterior(dataMatrix, classVector)
  labels    = unique(classVector);
  nClass    = length(labels);
  nDim      = size(dataMatrix,2);
  mixingP   = zeros(nClass,1);
  muMatrix  = zeros(nClass, nDim); 
  sigMatrix = zeros(nDim, nDim, nClass);
  
  for c = 1 : nClass
      
    thisClassFlag =(classVector==c);
    thisClassElem = dataMatrix(thisClassFlag,:);
    thisGaussian  = gmdistribution.fit(thisClassElem, 1);
    
    mixingP(c)       = sum(thisClassFlag);
    muMatrix(c,:)    = thisGaussian.mu;
    sigMatrix(:,:,c) = thisGaussian.Sigma;
    
  end
  
  mixingP = mixingP./sum(mixingP);  %normalize mixing P
  
  globalGmm = gmdistribution(muMatrix, sigMatrix, mixingP);
  PMatrix   = globalGmm.posterior(dataMatrix);
  
  x = sort(dataMatrix(:,1));
  y = sort(dataMatrix(:,2));
  
  figure;
  hold on;
  colors = ['r', 'b'];
  for c = 1 : nClass
    scatter(dataMatrix(classVector==c,1), dataMatrix(classVector==c,2), colors(c), 'filled');
  end
  ezcontour(@(x,y)pdf(globalGmm,[x,y]), [min(x), max(x)], [min(y),max(y)]);
  %pcolor(x, y, gmmPdf);
  %colormap jet;
  %shading interp;
  hold off;
  
end