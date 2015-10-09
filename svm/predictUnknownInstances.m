function predictUnknownInstances(fpath,modelpath,odir)
	
	load([fpath,"/datasumMatrix.mat"]);
	[NX featureList]=loadDatasumMatrix(fpath);
	l = readInLabels("~/Munka/Database","list_C.txt");
	C = [ datasumMatrix.C double(l) ];
	C(C(:,end)==0,:)=[];
	C = normalizeMatrixFromFile(C,fpath);
	load([modelpath,"/resultByFeature.mat"]);
	models = resultByFeature.models;
	bestFeat = resultByFeature.bestFeatures;
	y= NX(:,end);
	predictions.bestFeat = bestFeat;
	predictions.predictedLabels = [];
	
	for i=1:length(models)
		p = svmpredict(C(:,end),C(:,bestFeat(i,:).+1),models(i).model);
		predictions.predictedLabels = [ predictions.predictedLabels ; p' ];
		figure(i);
		clf;
		hold on;
		plotData(NX(:,bestFeat(i,:).+1),y);
		plotBoundary(models(i).model,[min(C(:,bestFeat(i,1))) max(C(:,bestFeat(i,1)))]);
		plotData([C(:,bestFeat(i,:).+1)],C(:,end),2,"y");
		plotData([C(:,bestFeat(i,:).+1)],C(:,end),3,"m");
		plotData([C(:,bestFeat(i,:).+1)],C(:,end),4,"g");
		plotPrediction([C(C(:,end)==2,bestFeat(i,:).+1)],p(C(:,end)==2));
		plotPrediction([C(C(:,end)==3,bestFeat(i,:).+1)],p(C(:,end)==3));
		plotPrediction([C(C(:,end)==4,bestFeat(i,:).+1)],p(C(:,end)==4));
		title([featureList{bestFeat(i,1)},'-',featureList{bestFeat(i,2)}]);
		hold off;
		saveas(gcf,[odir,"/img/2/predicted/",[featureList{bestFeat(i,1)},'-',featureList{bestFeat(i,2)}],".png"]);
	end	

	save([odir,"/result/1/predictions.mat"],"predictions");
end