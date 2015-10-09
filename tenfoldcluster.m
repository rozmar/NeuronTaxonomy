
acc = 0;

foldRatio = 1/10;

posindices = find(y==1);
posten = size(posindices,1)*foldRatio;
negindices = find(y==0);
negten = size(negindices,1)*foldRatio;

for j = 1 : size(bestFeatures.R,1)
  bF = bestFeatures.R(j,1);

  avgtrain = 0;
  avgtest = 0;
for i = 0 : floor(1/foldRatio)-1
  foldstartpos = round(1 + (i*posten));
  foldendpos = round(1+ (i+1)*posten) -1;
  foldstartneg = round(1 + (i*negten));
  foldendneg = round(1 + (i+1)*negten) -1;
  
  testindices = [ posindices(foldstartpos:foldendpos) ; negindices(foldstartneg:foldendneg) ];
  trainindices = [ setdiff(posindices,testindices) ; setdiff(negindices,testindices) ];
  
  trainset = X(trainindices,:);
  trainlabel = y(trainindices);
  testset = X(testindices,:);
  testlabel = y(testindices);
  
  IDX = [];
  
  for k  = 1 : 100
    [idx,c] = kmeans(trainset(:,bF),2,'emptyaction','singleton');
    idx(idx==2)=0;
    IDX = [ IDX ; idx ];
  end
  
  idx = mode(IDX);
      
  %plot2DCluster(trainset(:,bF),c,idx,'on',trainlabel,featureList{bF});
    
  confmatrix = calcConfusionMatrixClustering(trainset(:,bF),idx,trainlabel);
  
  %printf("%d. fold.\n", (i+1));
  %printf("Train accuracy: %f\n", (sum(confmatrix([1,4]))/sum(confmatrix)));
  
  idxtest = findClosestCentroids(testset(:,bF),c);
  idxtest(idxtest==2)=0;
  %plot2DCluster(testset(:,bF),c,idxtest,'on',testlabel,featureList{bF});
  
  confmattest = calcConfusionMatrixClustering(testset(:,bF),idxtest,testlabel);
  %printf("Test accuracy: %f\n", (sum(confmattest([1,4]))/sum(confmattest)));
   
  avgtrain +=  (sum(confmatrix([1,4]))/sum(confmatrix));
  avgtest += (sum(confmattest([1,4]))/sum(confmattest));
   
end

  printf("Average accuracy with feature %d\nOn train: %f\nOn test: %f\n", bF, (avgtrain/floor(1/foldRatio)), (avgtest/floor(1/foldRatio)));
  
  acc += (avgtest/floor(1/foldRatio));
end

  printf("Average on test set with %d fold: %f\n",floor(1/foldRatio) ,acc/size(bestFeatures.R,1))