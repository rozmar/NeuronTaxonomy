

function plotBestFeatures(imgODir)
	load("top3percentBestModel.mat","accuracyFeature");		%load learning result
	AC = accuracyFeature.ac(sum(accuracyFeature.ac(:,3:4),2)<2,:);	%select features less than 2 miss
	
	load("feats.mat","feats");				%load data
	A = [ feats.a ones(size(feats.a,1),1) ];
	B = [ feats.b zeros(size(feats.b,1),1) ];
	
	DS = [ A ; B ];
	NDS = normalizeMatrix(DS);
	Na = NDS(NDS(:,end)==1,:);
	Nb = NDS(NDS(:,end)==0,:);
	
	figure(1,"visible","on");
	clf;
	hold on;
	for i=1:size(AC,1)
		subplot(5,2,i);
		hold on;
		plot(Na(:,AC(i,1)),ones(1,size(Na,1)),'bo',"markersize",5);
		plot(Nb(:,AC(i,1)),ones(1,size(Nb,1)),'ro',"markersize",5);
		ylim([0 2]);
		hold on;
	end
	hold off;
	saveas(gcf,[imgODir,"/bestFeatures.png"]);
end