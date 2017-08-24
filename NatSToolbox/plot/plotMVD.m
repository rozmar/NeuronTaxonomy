function [outFig,outOffset] = plotMVD(meanVector, scale, figHandle, offset, type)

  meanVector = meanVector * scale;
  
  if nargin<3
    figHandle = figure;
    offset = 0;
  end
  
  ylim([-2,2]*scale);
  hold on;
  drawCircle([offset,0], scale);
  if strcmpi(type,'line')
    drawLine([offset,0],[real(meanVector)+offset,imag(meanVector)], 'r', 2);
  elseif strcmpi(type,'point')
    plot(real(meanVector)+offset,imag(meanVector), 'r+');
  end
  hold off;
  
  xlim([-2*scale, offset + 2*scale]);
  axis square;
  
  outFig = figHandle;
  outOffset = offset + (2.1*scale);
  
end