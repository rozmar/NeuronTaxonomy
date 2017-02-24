function aggregateACAndISI(resultStructArray, parameters)

  nFile = length(resultStructArray);
  nSegment = length(resultStructArray{1});
  
%   if nFile==1
%     return;
%   end
  
  averageResultStruct = resultStructArray{1};
  
  %% --------------------------
  %  Loop through each segment
  %% --------------------------
  for j = 1 : nSegment
      
    % Get the first segment
    thisAvgSegment = averageResultStruct(j).result;
    
    %% --------------------------
    %  Loop through each file and
    %  sum the values for each segm.
    %% --------------------------
    for i = 2 : nFile
      thisFile = resultStructArray{i};
      thisFileThisSegment = thisFile(j).result;
      thisAvgSegment.ISI.bins = thisAvgSegment.ISI.bins + thisFileThisSegment.ISI.bins;
      thisAvgSegment.AC.bins = thisAvgSegment.AC.bins + thisFileThisSegment.AC.bins;
    end
    %% --------------------------
    
    %% --------------------------
    %  Divide values by the num
    %  of files.
    %% --------------------------
    thisAvgSegment.ISI.bins = thisAvgSegment.ISI.bins ./ nFile;
    thisAvgSegment.AC.bins = thisAvgSegment.AC.bins ./ nFile;
    %% --------------------------
    
    averageResultStruct(j).result = thisAvgSegment;
  end
  %% --------------------------

  %% -------------------------
  %  Save the results
  %% -------------------------      
  plotACAndISI(averageResultStruct, 'average', parameters);
  %% -------------------------
    
  %% -------------------------
  %  Save the results
  %% -------------------------    
  if parameters.isSave
      oDir  = parameters.output.dir;
      fName = 'average';
      oPath = sprintf('%s%s_ac_isi_result.mat', oDir, fName);
      save(oPath, 'averageResultStruct');
  end
  %% -------------------------   
  
end