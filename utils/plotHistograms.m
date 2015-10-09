


function plotHistograms(fpath,predictions,outdir)
	load([fpath,"/datasumMatrix.mat"]);
	load([predictions,"/predictions.mat"]);
	load([fpath,"/featureList.mat"]);
	Y=predictions.predictedLabels;
	bestFeat = predictions.bestFeat;
	l = readInLabels("~/Munka/Database","list_C.txt");
	C = [ datasumMatrix.C double(l) ];
	C( C(:,end)==0 , : ) = [];
	X = [ datasumMatrix.A ones(size(datasumMatrix.A,1),1) ; datasumMatrix.B ones(size(datasumMatrix.B,1),1).*-1 ];
	
	for i=1:size(Y,1)
		yy=Y(i,:);
		figure(i);
		clf;
		hold on;
		hist(C(yy==1,bestFeat(i)+1),'edgecolor','r','facecolor','w');
		hist(C(yy==-1,bestFeat(i)+1),'edgecolor','b','facecolor','w');
		
		hist(X(X(:,end)==1,bestFeat(i)+1),'edgecolor','r','facecolor','r');
		hist(X(X(:,end)==-1,bestFeat(i)+1),'edgecolor','b','facecolor','b'); 
		title(featureList{bestFeat(i)});
		hold off;
		saveas(gcf,[outdir,"/histograms/",featureList{bestFeat(i)},".png"]);
	end
end