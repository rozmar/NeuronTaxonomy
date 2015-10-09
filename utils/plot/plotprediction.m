PM = makePermutation(4,2);
Known = X(y<3,bestFeatures);
UnKnown = X(y==3,bestFeatures);
for i = 1 : size(PM,1) 
    figure;
    clf;
    hold on;
    plot(Known(y==1,PM(i,1)),Known(y==1,PM(i,2)),'ro','MarkerFaceColor','r');
    plot(Known(y==2,PM(i,1)),Known(y==2,PM(i,2)),'bo','MarkerFaceColor','b');
    %plot(UnKnown(pred==1,PM(i,1)),UnKnown(pred==1,PM(i,2)),'rs','MarkerFaceColor','w');
    %plot(UnKnown(pred==2,PM(i,1)),UnKnown(pred==2,PM(i,2)),'bs','MarkerFaceColor','w');
    hold off;
    title([featureNames{bestFeatures(PM(i,1))},'-',featureNames{bestFeatures(PM(i,2))}]);
    print(['/home/borde/',[featureNames{bestFeatures(PM(i,1))},'-',featureNames{bestFeatures(PM(i,2))}],'.png'],'-dpng');
    close;
end;