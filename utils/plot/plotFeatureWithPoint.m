


function plotFeatureWithPoint(featX,featY,marker)
	if nargin<3
	  marker = '.';
	end
	if marker=='.'
	  markersize = 30;	
	else
	  markersize = 10;
	end
	hold on;
	plot(featX,featY,["k",marker],"markersize",markersize,'markerfacecolor','k');
	hold off;	
end