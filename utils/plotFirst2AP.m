% This function plots an AP and mark the specific points on it.
%
% In parameter expects the time axis, the sweep, and the first two AP.
function plotFirst2AP(x,Y,AP)
	load("/home/borde/Munka/NeuroScience/featureextractors/apFeatures.mat","featS");
	hold on;
	plot(x(AP(1,4)-2:AP(1,8)+2),Y(AP(1,4)-2:AP(1,8)+2),'b-');
	plot(x(AP(1,featS.thresholdPos)),AP(1,featS.thresholdV),'go');
	%plot(x(AP(2,featS.thresholdPos)),AP(2,featS.thresholdV),'go');
	plot(x(AP(1,8)),AP(1,featS.apEndV),'bo');
	plot(x(AP(1,3)),AP(1,featS.apMax),'mo');
	%plot(x(AP(1,29)),AP(1,30),'mo');
	hold off;
end
