


function clusterData(fpath, classnum)
	
	load([fpath,"/feats.mat"],"feats");
	fields = feats.f;

	%labeling the positive matrix
	pos = [ feats.a repmat(1,size(feats.a,1),1) ];
	%labeling the negative matrix
	neg = [ feats.b repmat(0,size(feats.b,1),1) ];

	%whole database
	database = [ pos ; neg ];
		
%	load([fpath,"/top3percentBestModel.mat"],"accuracyFeature");		%top 3 percent performace
%	AC = accuracyFeature.ac(find(sum(accuracyFeature.ac(:,3:4),2)<2),:);	%max 2 misses
%	numF = size(AC,1);	%number of features
%	bestFeats = AC(:,1)';

	numF = size(database,2);
	bestFeats = [1:1:numF];
	
	normalizedDataset = normalizeMatrix(database,fpath);
	shuffledData = shuffleMatrix(normalizedDataset);
	
	y = shuffledData(:,end);
		
	%for l=1:numF
		l=1;
		%l = 2;
		centroids = [];
		PM = makePermutation(numF, l);
				
		if ~exist("../clustered","dir")
			mkdir("../clustered");
		end
		
		if ~exist(["../clustered/",num2str(l)],"dir")
			mkdir(["../clustered/",num2str(l)]);
		end
		odname = ["../clustered/",num2str(l)];
		
		if l<3
			if ~exist(["../img/allclustered/",num2str(l)],"dir")
				mkdir(["../img/allclustered/",num2str(l)]);
			end
			imgodname = ["../img/allclustered/",num2str(l)];
			imgname = [];
		end
		
		printf("%d feature\nStarting %d multi multiset.\n",l,size(PM,1));
		confmatrix = [];
		for i=1:size(PM,1)
			printf("Feature %d.\n",i);
			
			fVec = shuffledData(:,[bestFeats(PM(i,:))]);
		
			centroid = runClustering(fVec,classnum);
			centroids = [centroids ; bestFeats(PM(i,:)) centroid'(:)' ];
		
			imgname = "clustering_";
			plotname = [];
			for fn=1:size(PM,2)-1
				imgname = [imgname,fields{bestFeats(PM(i,fn))},"-"] ;
				plotname = [plotname,fields{bestFeats(PM(i,fn))},"-"];
			end
			idx = findClosestCentroids(fVec, centroid);
			confmat = calcConfusionMatrixClustering(fVec,idx,y);
			
			confmatrix = [ confmatrix ; confmat ];
			
			if l<3
				plot2DCluster(fVec,centroid,idx,"off",y);
				saveas(gcf,[imgodname,"/",imgname,fields{bestFeats(PM(i,end))},'.png']);
			end
		end
		
		
		clusteringFeatures.cent = centroids;
		clusteringFeatures.confmat = confmatrix;
		clusteringFeatures.features = fields;
		
		save([odname,"/clusterCentroids.mat"],"clusteringFeatures");
		printf("%d size multiset finished.\n", size(PM,1));
	%end
end