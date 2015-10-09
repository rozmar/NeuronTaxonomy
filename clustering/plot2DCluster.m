


function plot2DCluster(X,centroids,idx,visibility,class,ttl)
	maxVals = max(X);
	minVals = min(X);
	blueNum = 0;
	redNum = 1;
	
  if size(X,2)==1
		cy=1;
	else
		cy=centroids(:,2);
	end
  
  if nargin > 4
	  cl1 = size(intersect(find(class==1), find(idx==1)),1);
	  cl2 = size(intersect(find(class==1), find(idx==0)),1);
	  if cl2>cl1
		  blueNum = 1;
	  	redNum = 0;	
  	end
  end
		
	figure("visible",visibility);
	clf;
  
  if nargin>4
    top=subplot(2,1,1);
    
  end
	
	hold on;
	if size(X,2)==1	
		yP = repmat(1,size(X(find(idx==redNum)),1),1);
		yN = repmat(1,size(X(find(idx==blueNum)),1),1);		
		maxVals = [ maxVals 1 ];
		minVals = [ minVals 1 ];
	else
		yP = X(find(idx==redNum),2);
		yN = X(find(idx==blueNum),2);
	end
	plot(X(find(idx==redNum),1),yP,'ro',"markersize",5,'linewidth',1);%,"markerfacecolor","r");
	plot(X(find(idx==blueNum),1),yN,'bs',"markersize",5,'linewidth',1);%,"markerfacecolor","b");
	plot(centroids(:,1),cy,'kx',"markersize",10,'linewidth',2);
  %xlim([minVals(1)-0.5 maxVals(1)+0.5]);
	ylim([minVals(2)-0.5 maxVals(2)+0.5]);
	hold off;	
  

  if nargin>4
    bot=subplot(2,1,2);
    hold on;
		if size(X,2)==1	
			yB = repmat(1,size(X(find(class==blueNum)),1),1);
			yR = repmat(1,size(X(find(class==redNum)),1),1);
		else
			yB = X(find(class==blueNum),2);
			yR = X(find(class==redNum),2);
		end
    
		plot(X(find(class==blueNum),1),yB,'bs',"markersize",5,'linewidth',1,"markerfacecolor","b");
		plot(X(find(class==redNum),1),yR,'ro',"markersize",5,'linewidth',1,"markerfacecolor","r");
    
    plot(centroids(:,1),cy,'kx',"markersize",10,'linewidth',2);
	
	  %xlim([minVals(1)-0.5 maxVals(1)+0.5]);
	  ylim([minVals(2)-0.5 maxVals(2)+0.5]);
	  hold off;	
	end
		
  if nargin==6
    title(top,ttl);
  end
end
