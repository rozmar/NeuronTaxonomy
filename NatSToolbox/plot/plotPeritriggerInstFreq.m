function plotPeritriggerInstFreq(resultStructure, parameters)
  
  %% ------------------------------
  %  Cut slices around triggers from inst. freq.
  %% ------------------------------
  instFrequencyMatrix = resultStructure.instFrequencyMatrix;
  
  figure; 
  plotMeanAndSem(mean(instFrequencyMatrix(:,1:end-1),1), [], parameters.plot);
  title(strjoin({parameters.plot.title,parameters.plot.fileName}));
  %plot(timeVector, mean(instFreqMatrix,1));
  %figure;
  %plot(timeVector, instFreqMatrix);
  %% ------------------------------  
end