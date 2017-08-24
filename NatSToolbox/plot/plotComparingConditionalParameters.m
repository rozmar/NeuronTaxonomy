function plotComparingConditionalParameters(dataVector, classVector)

  labels = unique(classVector);

  figure;
  for i = 1 : 2
    subplot(1,2,i);
    thisGroupData = dataVector(classVector==labels(i));
    [n,xc] = hist(thisGroupData);
    [f,xi] = ksdensity(thisGroupData);
    hold on;
    n = n./sum(n);
    f = f./trapz(f);
    bar(xc, n);
    plot(xi, f, 'r-');
    title(sprintf('label = %d', labels(i)));
    
    [maxval, maxpos] = max(f);
    fprintf('Maximal value %f at %f\n', maxval, xi(maxpos));
  end
  
end