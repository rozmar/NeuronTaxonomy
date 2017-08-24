function plotACAndISI(segmentStructure, plotTitle, parameters)

  %% -------------------------
  %  Parameters initialization
  %% -------------------------
  isSave = (nargin>2)&&(parameters.isSave);
  if isSave
    oDir = parameters.output.dir;
  end
  %% -------------------------

  %% -------------------------
  %  Plot results by type
  %% -------------------------
  acFig = figure;
  isiFig = figure;
  nSegment = length(segmentStructure);
  legendArray = cell(nSegment, 1);
  for i = 1 : nSegment
    thisSegmentResult = segmentStructure(i).result;
    
    figure(acFig);
    hold on;
    plot(thisSegmentResult.AC.xtick, thisSegmentResult.AC.bins, '-', 'Color', segmentStructure(i).color, 'linewidth', 2);
    hold off;
    
    figure(isiFig);
    hold on;
    plot(thisSegmentResult.ISI.xtick, thisSegmentResult.ISI.bins, '-', 'Color', segmentStructure(i).color, 'linewidth', 2);
    hold off;
    
    legendArray{i} = segmentStructure(i).title;
  end
  %% -------------------------
  
  %% -------------------------
  %  Set title
  %% -------------------------
  figure(acFig);
  legend(legendArray);
  title(sprintf('Autocorrelation for %s',strrep(plotTitle,'_','\_')));
   
  figure(isiFig);
  legend(legendArray);
  title(sprintf('InterspikeInterval for %s',strrep(plotTitle,'_','\_')));
  
  if strcmpi(segmentStructure(1).result.ISI.scale, 'log')
    ax = gca;
    set(ax,'XScale','log'); 
  end
  %% -------------------------
  
  %% -------------------------
  %  Save
  %% -------------------------
  if isSave
    saveas(acFig, sprintf('%s%s_ac.fig', oDir, plotTitle));
    saveas(isiFig, sprintf('%s%s_isi.fig', oDir, plotTitle));
  end
  %% -------------------------

end