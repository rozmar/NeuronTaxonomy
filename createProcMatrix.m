

function createProcMatrix(datasumPath,outputPath,pM)
  load([datasumPath,'/datasumMatrix.mat']);
  A = datasumMatrix.A;
  B = datasumMatrix.B;
  files = datasumMatrix.fileName;
  X = [ A ones(size(A,1),1) ; B ones(size(B,1),1).*2 ];
  y = X(:,end);
  X = X(:,2:end-1);
  NX = normalizeMatrix(X);
  procMatrix.X = X;
  procMatrix.y = y;
  procMatrix.NX = NX;
  procMatrix.fileName = files;
  procMatrix.featureList = pM.featureList;
  save([outputPath,'/procMatrix.mat'],'procMatrix');
end