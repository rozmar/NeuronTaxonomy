function learning = learnAndPredict(X,y,I,featureList)
  y(y==0)=-1;
  for i=1:length(I)
    F = X(y<2,i);
    model = svmtrain(y(y<2),F,' -t 0 -q');
    models(i).model = model;
%    plotDataWithBoundary(F,y(y<2),model,"on",0);
    prediction = svmpredict(y(y>1),X(y>1,i),model,' -q');
    prediction'
    preds(i).prediction = prediction;
    %plotPrediction(X(:,i),y,prediction,model,featureList);
  end	
  learning.models = models;
  learning.preds = preds;
end