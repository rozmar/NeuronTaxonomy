for i = 1 : size(bestFeatures.R,1) ; 
 F = NX(:,bestFeatures.R(i,1));
 [idx,c] = kmeans(F,2);
 idx(idx==2)=0;
 if idx(1)==0
   idx = repmat(1,size(idx)) .- idx;	
 end
 cfm = calcConfusionMatrixClustering(F,idx,y);
 acc = ((sum(cfm([1,4])))/(sum(cfm)))*100;
 plot2DCluster(F,c,idx,'off',y,[featureList{bestFeatures.R(i,1)},' - Accuracy: ',num2str(acc),'%']);
 saveas(gcf,[outputdir,'/',num2str(i),'_',featureList{bestFeatures.R(i,1)},'.png']);
end