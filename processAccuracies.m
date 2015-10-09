function processAccuracies(learnedDir,fname,fieldName)
	oldDir = pwd;
	eval(["cd ",learnedDir]);
	dirs = dir;
	mins = [];
	maxs = [];
	avgs = [];
	figure(2,"visible","on");
	clf;
	hold on;
	for i=1:length(dirs)
		if dirs(i).isdir==0 || strcmp(dirs(i).name,".")==1 || strcmp(dirs(i).name,"..")==1
			continue;
		end
		load([dirs(i).name,"/",fname,".mat"],fieldName);
		%ACM = eval(["(",fieldName,").cent"]);
		CM = eval(["(",fieldName,").confmatrix"]);
		featureNum = str2num(dirs(i).name);
		missingNum = sum(CM(:,2:3),2);
		%printf("%s\n",dirs(i).name);
		maxMiss = 1-(max(missingNum)/sum(CM(1,1:4)));
		minMiss = 1-(min(missingNum)/sum(CM(1,1:4)));
		avgMiss = 1-(mean(missingNum)/sum(CM(1,1:4)));
		mins(featureNum) = minMiss;
		maxs(featureNum) = maxMiss;
		avgs(featureNum) = avgMiss;
		plot(featureNum,maxMiss,"bo",featureNum,minMiss,"ro");
	end
	%plot(avgs,'-k@',mins,'ro',maxs,'bo');
	xi = linspace(1,10);
	yi = interp1(avgs,xi);
	plot(xi,yi,'k-');
	xlim([1 11]);
	ylim([0 1.1]);
	hold off;
	saveas(gcf,"learningAccuracies.png");
	eval(["cd ",oldDir]);
end