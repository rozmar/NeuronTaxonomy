

function plotDataWithBoundary(X,y,model,visibility,marg)
	if nargin == 3
		visibility = "off";
	end

	figure(randi(1000),"visible",visibility);
	clf;
	hold on;
	plotData(X,y);
	plotBoundary(model,[min(X(:,1))-1 max(X(:,1))+1],marg);
	xlim([min(X(:,1))-1 max(X(:,1))+1]);
	hold off;
end