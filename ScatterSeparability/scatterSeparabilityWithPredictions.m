function R = scatterSeparabilityWithPredictions(X,y,list,learning)
  models = learning.models;
  preds = learning.preds;
  R = [];
  for i=1:length(list)
    Y = y(y<2);
    Y = [ Y ; preds(i).prediction ];
    SS = scatterSeparability(X(:,list(i)),Y);
    R = [ R ; double(list(i)) SS ];
  end
  
  R(isnan(R(:,2)),2)=0;
  [~,idx] = sort(R(:,2),'descend');
  R = R(idx,:);
end 	