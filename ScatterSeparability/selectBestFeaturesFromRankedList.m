function bestFeats = selectBestFeaturesFromRankedList(X,R,het,fList,y)
  thresh = find(R(:,2)>=het,1,'last');
  R = R(1:thresh,:);
  bestFeatureSet = 0;
  while size(R,1)>0
    bestFeat = R(1,1:2);
    fprintf('bestFeat: %d\n', bestFeat(1,1) );
    R = [ R(:,1:2) corr( X(:,bestFeat(1,1)) , X(:,R(:,1)) )' ];
    
    if isnan(R(1,3))
      R(1,:)=[];
      continue;	
    end
    bFC = R(abs(R(:,end))>0.75,:);
    
    fprintf('Correlating: %d\n', size(bFC,1));
        
    bestFeatureSet=bestFeatureSet+1;
    fprintf('bestFeatureSet: %d\n', bestFeatureSet);
    bestFeats(bestFeatureSet).R = bFC(:,:);
    R(abs(R(:,end))>0.75,:) = [];    
    fprintf('Remaining: %d\n', size(R,1));
  end	
end