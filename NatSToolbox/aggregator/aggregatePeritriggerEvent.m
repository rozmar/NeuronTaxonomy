function aggregatePeritriggerEvent(resultStructArray, parameters)

  %% ---------------------------
  %  Initialization
  %% ---------------------------
  resultStructArray = convertArrayOfStruct(resultStructArray);
  nFile             = length(resultStructArray);
  nCategory         = size(resultStructArray(1).meanMHistogram,1);
  binNumber         = size(resultStructArray(1).meanMHistogram,2);
  
  weightVector      = zeros(nFile,1);
  eventArray        = {};
  
  countByCategory   = zeros(nCategory, binNumber);
  meansByCategory   = zeros(nCategory, binNumber);
  freqByCategory    = zeros(nCategory, binNumber);
  probByCategory    = zeros(nCategory, binNumber);
  
  semCByCategory     = zeros(nCategory, binNumber);
  semMByCategory     = zeros(nCategory, binNumber);
  semFByCategory     = zeros(nCategory, binNumber);
  semPByCategory     = zeros(nCategory, binNumber);
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
  for f = 1 : nFile
    weightVector(f) = getWeight(resultStructArray(f), parameters.plot);
    eventArray      = [eventArray;resultStructArray(f).peritriggerEvents];
  end
  
  
  for i = 1 : nCategory
     
     thisCategoryCount = zeros(nFile, binNumber);
     thisCategoryMean = zeros(nFile, binNumber);
     thisCategoryFreq = zeros(nFile, binNumber);
     thisCategoryProb = zeros(nFile, binNumber);
     
     % For each f file, get the ith category
     for f = 1 : nFile
       thisCategoryCount(f,:) = resultStructArray(f).meanCHistogram(i,:);
       thisCategoryMean(f,:)  = resultStructArray(f).meanMHistogram(i,:);
       thisCategoryFreq(f,:)  = resultStructArray(f).meanFHistogram(i,:);
       thisCategoryProb(f,:)  = resultStructArray(f).meanPHistogram(i,:);
       
       
     end
     
     % Calculate mean and sem for a category between files
     countByCategory(i,:) = calculateWeightedSum(thisCategoryCount, weightVector)./sum(weightVector);
     meansByCategory(i,:) = calculateWeightedSum(thisCategoryMean, weightVector)./sum(weightVector);
     freqByCategory(i,:)  = calculateWeightedSum(thisCategoryFreq, weightVector)./sum(weightVector);
     probByCategory(i,:)  = calculateWeightedSum(thisCategoryProb, weightVector)./sum(weightVector);
     
     semCByCategory(i,:) = sqrt(var(thisCategoryCount, weightVector, 1))./sqrt(nFile);
     semMByCategory(i,:) = sqrt(var(thisCategoryMean, weightVector, 1))./sqrt(nFile);
     semFByCategory(i,:) = sqrt(var(thisCategoryFreq, weightVector, 1))./sqrt(nFile);
     semPByCategory(i,:) = sqrt(var(thisCategoryProb, weightVector, 1))./sqrt(nFile);
  end
  %% ---------------------------
  
  %% ---------------------------
  %  Put results into  structure
  %% ---------------------------
  averageResultStructure.mode            = 'overall';
  averageResultStructure.meanCHistogram  = countByCategory;
  averageResultStructure.meanMHistogram  = meansByCategory;
  averageResultStructure.meanFHistogram  = freqByCategory;
  averageResultStructure.meanPHistogram  = probByCategory;
  averageResultStructure.semCHistogram   = semCByCategory;
  averageResultStructure.semMHistogram   = semMByCategory;
  averageResultStructure.semFHistogram   = semFByCategory;
  averageResultStructure.semPHistogram   = semPByCategory;
  averageResultStructure.peritriggerEvents = eventArray;
  %% ---------------------------
  
  %% ---------------------------
  %  Plot overall average, if needed
  %% ---------------------------
  if parameters.plot.globalAverage
    plotPeritriggerEvent(averageResultStructure, parameters);  
  end
  %% ---------------------------
  
  %% ---------------------------
  %  Save data if needed
  %% ---------------------------
  if isSave(parameters)  
    outputFileName = strjoin({'overall',lower(parameters.channel.event.title),'around',lower(parameters.channel.trigger.title)},'_');
    dataPath = strcat(parameters.output.dir,'/',outputFileName,'.mat');
    save(dataPath, 'averageResultStructure');
  end  
  %% ---------------------------
  
end

function summedVector = calculateWeightedSum(valueMatrix, weightVector)
  weightMatrix = weightVector*ones(1,size(valueMatrix,2));
  summedVector = sum(valueMatrix.*weightMatrix,1);
end

% Get the weight for the averaging. If the averging mode is weighted, the
% weights will be the number of triggers. Else, each weight will be 1.
function weight = getWeight(resultStructure, parameters)
  if strcmpi(parameters.averagingMode, 'weighted')
    weight = length(resultStructure.peritriggerEvents);
  elseif strcmpi(parameters.averagingMode, 'normal')
    weight = 1;  
  end
end