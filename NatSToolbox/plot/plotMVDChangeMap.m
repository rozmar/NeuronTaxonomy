function plotMVDChangeMap(meanVectors)

  nCycle = length(meanVectors);
  yCoords = angle(meanVectors');
  
  evalX = linspace(-3,3,361);
  evalX = evalX(1:end-1)';
  plotMap = zeros(360, nCycle);
  shift = @(angl)360+angl;
  cyclesToExamine = 1:nCycle;
  for i = cyclesToExamine
    thisAngle = floor(circ_rad2ang(angle(meanVectors(i)))); 
    if isnan(thisAngle)
      continue;
    end
    if thisAngle<0
      thisAngle = shift(thisAngle);
    end
    plotMap(:, i) = normpdf(evalX, -3 + thisAngle*0.016, 1);
  end
  
  plotMap = [plotMap(181:360,:);plotMap(1:180,:)];
  
  pcolor((cyclesToExamine)/10000, linspace(0,1,360), plotMap(:,cyclesToExamine));
  shading interp;
  colormap jet;

end
