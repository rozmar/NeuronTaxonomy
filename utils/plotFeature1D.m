function plotFeature1D(fvec1,fvec2,tit)
	v1 = fvec1;
	v2 = fvec2;
	figure;
    hold on;
	plot(v1,ones(length(v1),1)*0.25,'bo','MarkerSize',5,'MarkerFaceColor','b');
    plot(v2,zeros(length(v2),1),'ro','MarkerSize',5,'MarkerFaceColor','r');
    ylim([-0.25 0.5]);
    hold off;
	title(tit);
end