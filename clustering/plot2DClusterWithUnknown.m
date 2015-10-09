


function plot2DClusterWithUnknown(X,centroids,idx,visibility,class)
	maxVals = max(X);
	minVals = min(X);
	blueNum = 0;
	redNum = 1;
	
	idx(idx==2)=0;
	
	cl1 = size(intersect(find(class(class<2)==1), find(idx(class<2)==1)),1);
	cl2 = size(intersect(find(class(class<2)==1), find(idx(class<2)==0)),1);
	
	if cl2>cl1
		idx(idx==0)=2;
		idx(idx==1)=0;
		idx(idx==2)=1;
	end
		
	figure('visible',visibility);
	clf;
	hold on;
	
	if size(X,2)==1	
		yP = repmat(1,size(X(find(idx==1)),1),1);
		yN = repmat(1,size(X(find(idx==2)),1),1);		
		maxVals = [ maxVals 1 ];
		minVals = [ minVals 1 ];
	else
		yP = X(find(idx==1),2);
		yN = X(find(idx==2),2);
	end
	%plot(X(find(idx==1),1),yP,'bo',"markersize",7,"markerfacecolor","b");
	%plot(X(find(idx==2),1),yN,'ro',"markersize",7,"markerfacecolor","r");
	
	if nargin==5
		if size(X,2)==1	
			yB = repmat(1,size(X(find(class(class<2)==blueNum)),1),1);
			yR = repmat(1,size(X(find(class(class<2)==redNum)),1),1);
			
			yBA = repmat(1,size(idx(idx==blueNum),1),1);
			yRA = repmat(1,size(idx(idx==redNum),1),1);
		else
			yB = X(find(class==blueNum),2);
			yR = X(find(class==redNum),2);
			
			yBA = X(find(idx==blueNum),2);
			yRA = X(find(idx==redNum),2);
		end
		
		plot(X(find(class(class<2)==blueNum),1),yB,'bo','markersize',5,'markerfacecolor','b');
		plot(X(find(class(class<2)==redNum),1),yR,'ro','markersize',5,'markerfacecolor','r');
		
		plot(X(find(idx==blueNum),1),yBA,'bo','markersize',5);
		plot(X(find(idx==redNum),1),yRA,'ro','markersize',5);		
	end
	
	if size(X,2)==1
		cy=1;
	else
		cy=centroids(:,2);
	end
	plot(centroids(:,1),cy,'kx','linewidth',5);
	
	xlim([minVals(1) maxVals(1)]);
	ylim([minVals(2) maxVals(2)]);
	hold off;	
end