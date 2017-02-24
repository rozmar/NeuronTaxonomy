function aggregatePEC(resultStructArray, parameters) 
  %% ---------------------------
  %  Initialization
  %% ---------------------------
  resultStructArray = convertArrayOfStruct(resultStructArray);
  nFile             = length(resultStructArray);
  nCategory         = size(resultStructArray(1).meanHistogram,1);
  binNumber         = size(resultStructArray(1).meanHistogram,2);
  
  meanCountByCategory = zeros(nCategory, binNumber);
  meanMeanByCategory  = zeros(nCategory, binNumber);
  
  semCountByCategory = zeros(nCategory, binNumber);
  semMeanByCategory  = zeros(nCategory, binNumber);  
  %% ---------------------------
  
  %% ---------------------------
  % Skip if we have only 1 file.
  %% ---------------------------
  if nFile==1
    return;
  end
  %% ---------------------------
  
  %% ---------------------------
  %  Loop through categories and
  %  collect from each file array.
  %% ---------------------------
  for i = 1 : nCategory
     
     thisCategoryCount = zeros(nFile, binNumber);
     thisCategoryMean  = zeros(nFile, binNumber);
     
     % For each f file, get the ith category
     for f = 1 : nFile
       thisCategoryCount(f,:) = resultStructArray(f).countHistogram(i,:);
       thisCategoryMean(f,:)  = resultStructArray(f).meanHistogram(i,:);
     end
     
     % Calculate mean and sem for a category between files
     meanCountByCategory(i,:) = mean(thisCategoryCount,1);
     meanMeanByCategory(i,:)  = mean(thisCategoryMean,1);
     
     semCountByCategory(i,:) = std(thisCategoryCount, 0, 1)./sqrt(nFile);
     semMeanByCategory(i,:)  = std(thisCategoryMean, 0, 1)./sqrt(nFile);
  end
  
  % Get mean vector for each cell
  meanVectorVector = zeros(nFile,1);
  for f = 1 : nFile
    meanVectorVector(f) = resultStructArray(f).cumulativeMean;
  end
  %% ---------------------------
  
  %% ---------------------------
  %  Put results into structure
  %% ---------------------------
  averageResultStructure.mode                = 'overall';
  averageResultStructure.meancountHistogram  = meanCountByCategory;
  averageResultStructure.meanmeanHistogram   = meanMeanByCategory;
  averageResultStructure.semcountHistogram   = semCountByCategory;
  averageResultStructure.semmeanHistogram    = semMeanByCategory;
  averageResultStructure.meanVectorVector    = meanVectorVector;
  %% ---------------------------
  
  
  %% ---------------------------
  %  Plot overall average, if needed
  %% ---------------------------
  if parameters.plot.globalAverage
    plotPEC(averageResultStructure, parameters);  
  end
  %% ---------------------------
  
  %% ---------------------------
  %  Save data if needed
  %% ---------------------------
  if isSave(parameters)  
    outputFileName = strjoin({'overall',lower(parameters.channel.eventTitle),lower(parameters.channel.sectionTitle),'phase_coupling'},'_');
    dataPath = strcat(parameters.output.dir,'/',outputFileName,'.mat');
    save(dataPath, 'averageResultStructure');
  end  
  %% ---------------------------  
end