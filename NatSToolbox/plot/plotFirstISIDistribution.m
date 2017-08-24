function plotFirstISIDistribution(resultStructure, parameters)

  baseTitle = parameters.plot.title;
  
  isiDistributionBefore = resultStructure.isiDistributionBefore;
  isiDistributionAfter = resultStructure.isiDistributionAfter;
  
  if strcmpi(parameters.plot.yScale,'prob')
    isiDistributionBefore = isiDistributionBefore./sum(isiDistributionBefore);
    isiDistributionAfter = isiDistributionAfter./sum(isiDistributionAfter);
  end
  
  figure;
  subplot(1,2,1);
  parameters.plot.title = [baseTitle,' before'];
  plotMeanAndSem(isiDistributionBefore, [], parameters.plot);
  subplot(1,2,2);
  parameters.plot.title = [baseTitle,' after'];
  plotMeanAndSem(isiDistributionAfter, [], parameters.plot);

  %% ----------------------------
  %  Save the plot
  %% ----------------------------
  if isSave(parameters)
    savePlot(gcf, resultStructure.mode, parameters);
  end
  %% ----------------------------
  
end

% Save the plot to the output directory.
function savePlot(figHandle, plotMode, parameters)

  %% ----------------------------
  %  Create output file name/path
  %% ----------------------------
  outputDirName  = getOutputDir(parameters);
  outputFileName = generateFileName(parameters, plotMode);
  outputFileName = strjoin({outputFileName,parameters.plot.mode},'_');
  %% ----------------------------
 
  %% ----------------------------
  %  Save to file
  %% ----------------------------
  saveas(figHandle, strcat(outputDirName,'fig/',outputFileName,'.fig'));
  print(figHandle, strcat(outputDirName,'png/',outputFileName,'.png'), '-dpng');
  %% ----------------------------
end

% Generate filename for the plots
function generatedFileName = generateFileName(parameters, plotMode)

  if strcmpi(plotMode, 'single')
    prefix = parameters.plot.fileName;
  else
    prefix = 'average';
  end
  
  generatedFileName = strjoin({prefix,'around',lower(parameters.channel.trigger.title),'first_isi'},'_');
end