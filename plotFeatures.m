function plotFeatures(datasumPath,imgOutputDir,featureIndex)
	
	load([datasumPath,"/datasumMatrix.mat"],"datasumMatrix");
	load([datasumPath,"/featureList.mat"],"featureList");
	
	A = datasumMatrix.A;
	B = datasumMatrix.B;
	
	if nargin==3
		for i=1:size(featureIndex,1)
			figure(i,"visible","off");
			clf;
			hold on;
			plot(A(:,featureIndex(i)+1),repmat(0,1,size(A,1)),'r@');
			plot(B(:,featureIndex(i)+1),repmat(0,1,size(B,1)),'b@');
			title(featureList{featureIndex(i)});
			ylim([-1 1]);
			hold off;
			saveas(gcf,[imgOutputDir,"/",featureList{featureIndex(i)},'.png']);
		end

	else
		for i=2:length(featureList)
			figure(i,"visible","off");
			clf;
			hold on;
			plot(A(:,i),repmat(0,1,size(A,1)),'r@');
			plot(B(:,i),repmat(0,1,size(B,1)),'b@');
			title(featureList{i});
			ylim([-1 1]);
			hold off;
			saveas(gcf,[imgOutputDir,"/",featureList{i-1},'.png']);
		end
	end
end
