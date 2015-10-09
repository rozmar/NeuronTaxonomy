
% fpath - where is the datasumMatrix
% savepath - where to save the results
% imgpaht - path of the plots
% onlyBest - 0 - all feature 1 - only the best features
% bestFeatureFile - file which contains best feature (meaningful only if we search for only the best)
% plotting - 0 don't plot anyting 1 - plot decision boundary
% printStat - 0 - print nothing 1 - print only number of processed features 2 - print accuracies
% learnType - 0 - logistic regression - 1 - SVM
function learnModel(fpath,savepath,imgpath,onlyBest,bestFeatureFile,bestFeatureName,plotting,printStat,learnType)
	printf("Loading datasum matrix.\n");

	[shuffledData fields files] = loadDatasumMatrix(fpath);

	printf("Matrix prepared for learning.\n");
	%select the features to examine
	if onlyBest==0
		numF = size(shuffledData,2)-2;
		bestFeats = [ (1:1:numF)' ];
	elseif onlyBest==1
		load(bestFeatureFile,(bestFeatureName));	%without ahp
		bestFeats = eval(bestFeatureName)';	%index of best features
		numF = size(bestFeats,2);		%number of features
	end
		
	%for l=2:numF
		%l = 1;
		l = 2;
		
		if learnType==0	
			thetas = [];
		elseif learnType==1
			models = {};
		end
		confmatrix = [];
		bestFeatures = [];
		
		printf("Making permutation.\n");
		PM = makePermutation(numF, l);
	       	printf("Permutation made.\n");

		if ~exist([savepath,"/",num2str(l)],"dir")
			mkdir([savepath,"/",num2str(l)]);
		end
		odname = [savepath,"/",num2str(l)];

		if ~exist([imgpath,"/",num2str(l)],"dir")
			mkdir([imgpath,"/",num2str(l)]);
		end
		imgdir = [imgpath,"/",num2str(l)];
		
		for i=1:size(PM,1)
			
			
			printf("Started learning %d. feature\n",bestFeats(PM(i,:)));
			
			%get the best features from database and the label too
			fVec = shuffledData(:,[bestFeats(PM(i,:)).+1 end]);
			
			%eliminate outlayers
			%fVec = fVec(find(abs(fVec(:,1)-mean(fVec(:,1)))<=std(fVec(:,1))),:);	
		
			if learnType==0							
				[confmat theta missedIndex] = runLogReg(fVec, fVec,printStat);	%get the result (confusion matrix and corresponding thetas)
				thetas = [ thetas ; theta' ];
			elseif learnType==1
				fVec(fVec(:,end)==0,end)=-1;
				[model] = svmtrain(fVec(:,end), fVec(:,1:end-1),' -t 0');
				pred = svmpredict(fVec(:,end), fVec(:,1:end-1), model)';
				tp = size(intersect(find(fVec(:,end)==1),find(pred==1)),2);
				tn = size(intersect(find(fVec(:,end)==-1),find(pred==-1)),2);
				fp = size(intersect(find(fVec(:,end)==-1),find(pred==1)),2);
				fn = size(intersect(find(fVec(:,end)==1),find(pred==-1)),2);
				confmat = [ tp fn fp tn ]
				models(i).model=model; 
			end
			%save the results
			confmatrix = [confmatrix ; confmat ];
			bestFeatures = [ bestFeatures ; bestFeats(PM(i,:)) ];
			
			if plotting==1 && ( (learnType==0 && l==2) || (learnType==1 && l<=2) )
			  imgname = [imgdir,"/",num2str(l),"slearning_"];
			  plotname = [];
			
			  for fn=1:size(PM,2)-1
			    imgname = [imgname,fields{bestFeats(PM(i,fn))},"-"] ;
			    plotname = [plotname,fields{bestFeats(PM(i,fn))},"-"];
			  end
			  imgname = [imgname,fields{bestFeats(PM(i,end))}] ;
			  if learnType == 0
				plotData(fVec(:,1:end-1),fVec(:,end));
			  elseif learnType==1
				plotDataWithBoundary(fVec(:,1:end-1),fVec(:,end),model);
			  end
			  saveas(gcf,[imgname,".png"]);
			end
			
			if printStat==2
				for fn=1:size(PM,2)-1
					printf("%s-",fields{bestFeats(PM(i,fn))});
				end
				printf("%s accuracy: %f\n", fields{bestFeats(PM(i,end))}, ((confmat(1)+confmat(4))/(sum(confmat))));
			elseif printStat==1
				printf("%d/%d\n",i,size(PM,1));	
			end
			
			
		end
		
		resultByFeature.confmatrix = confmatrix;
		resultByFeature.bestFeatures = bestFeatures;
		if learnType==0
			resultByFeature.thetas = thetas;
		elseif learnType==1
			resultByFeature.models = models;
		end
		
		save([odname,"/resultByFeature.mat"],"resultByFeature");

	%end
end
