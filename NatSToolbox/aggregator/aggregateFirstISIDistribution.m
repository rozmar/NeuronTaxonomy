function aggregateFirstISIDistribution(resultStructArray, parameters)

  resultStructArray = convertArrayOfStruct(resultStructArray);
  nFile             = length(resultStructArray);
  
  
  %% ---------------------------
  % Skip if we have only 1 file.
  %% ---------------------------
  if nFile==1
    return;
  end
  %% ---------------------------  
  
  beforeDistMatrix = [];
  afterDistMatrix  = [];
  
  for f = 1 : nFile
    beforeDistMatrix = [beforeDistMatrix;resultStructArray(f).isiDistributionBefore'];
    afterDistMatrix = [afterDistMatrix;resultStructArray(f).isiDistributionAfter'];
  end
  
  accumulatedResultStructure.mode = 'average';
  accumulatedResultStructure.isiDistributionBefore = sum(beforeDistMatrix,1);
  accumulatedResultStructure.isiDistributionAfter = sum(afterDistMatrix,1);
  
  %% ---------------------------
  %  Save data if needed
  %% ---------------------------
  if isSave(parameters)  
    outputFileName = strjoin({'average','isi_dist','around',lower(parameters.channel.trigger.title)},'_');
    dataPath = strcat(getOutputDir(parameters),'/',outputFileName,'.mat');
    save(dataPath, 'accumulatedResultStructure');
  end  
  %% ---------------------------
  
  parameters.plot.title = 'Average of first ISI distribution';
  plotFirstISIDistribution(accumulatedResultStructure, parameters);
  
end